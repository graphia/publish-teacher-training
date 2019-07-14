require 'rails_helper'

feature 'Course details', type: :feature do
  let(:current_recruitment_cycle) { build(:recruitment_cycle) }
  let(:provider) { build(:provider, provider_code: 'A0', accredited_body?: false, sites: [site1, site2]) }
  let(:course) do
    build :course,
          qualifications: %w[qts pgce],
          study_mode: 'full_time',
          start_date: Time.zone.local(2019),
          sites: [site1, site2],
          provider: provider,
          accrediting_provider: provider,
          open_for_applications?: true,
          recruitment_cycle: current_recruitment_cycle
  end
  let(:site1) { build(:site, location_name: 'London') }
  let(:site2) { build(:site, location_name: 'Manchester') }
  let(:site_status1) do
    build(:site_status, :full_time, site: site1, status: 'running')
  end
  let(:site_status2) do
    build(:site_status, :part_time, site: site2, status: 'suspended')
  end
  let(:course_response) do
    course.to_jsonapi(
      include: [:sites, :accrediting_provider, :recruitment_cycle, provider: :sites]
    )
  end

  before do
    stub_api_v2_request("/recruitment_cycles/#{current_recruitment_cycle.year}", current_recruitment_cycle.to_jsonapi)
    stub_omniauth
    stub_api_v2_request(
      "/recruitment_cycles/#{course.recruitment_cycle.year}" \
      "/providers/#{provider.provider_code}" \
      "/courses/#{course.course_code}" \
      "?include=sites,provider.sites,accrediting_provider",
      course_response
    )
  end

  let(:course_details_page) { PageObjects::Page::Organisations::CourseDetails.new }

  scenario 'viewing the course details page' do
    visit "/organisations/A0/#{course.recruitment_cycle.year}/courses/#{course.course_code}/details"

    expect(course_details_page)
      .to be_displayed(provider_code: provider.provider_code, course_code: course.course_code)

    expect(course_details_page.caption).to have_content(
      course.description
    )
    expect(course_details_page.title).to have_content(
      "#{course.name} (#{course.course_code})"
    )
    expect(course_details_page.subjects).to have_content(
      course.subjects.sort.join('').to_s
    )
    expect(course_details_page.qualifications).to have_content(
      'PGCE with QTS'
    )
    expect(course_details_page.study_mode).to have_content(
      'Full time'
    )
    expect(course_details_page.start_date).to have_content(
      'January 2019'
    )
    expect(course_details_page.name).to have_content(
      course.name
    )
    expect(course_details_page.description).to have_content(
      course.description
    )
    expect(course_details_page.course_code).to have_content(
      course.course_code
    )
    expect(course_details_page.locations).to have_content(
      site1.location_name
    )
    expect(course_details_page.locations).to have_content(
      site2.location_name
    )
    expect(course_details_page.edit_locations_link).to have_content(
      "Change location"
    )
    expect(course_details_page).not_to have_manage_provider_locations_link
    expect { course_details_page.apprenticeship }.to raise_error(Capybara::ElementNotFound)
    expect(course_details_page.funding).to have_content(
      'Fee paying (no salary)'
    )
    expect(course_details_page.accredited_body).to have_content(
      provider.provider_name
    )
    expect(course_details_page.is_send).to have_content(
      'No'
    )
    expect(course_details_page.level).to have_content(
      'Secondary'
    )
    expect(course_details_page).to have_entry_requirements
  end

  context 'when the provider only has one location' do
    let(:provider) { build(:provider, provider_code: 'A0', accredited_body?: true, sites: [site1]) }
    let(:course) do
      build :course,
            site_statuses: [site_status1],
            provider: provider,
            ucas_status: 'new',
            recruitment_cycle: current_recruitment_cycle
    end

    scenario 'viewing the course details page' do
      visit "/organisations/A0/#{course.recruitment_cycle.year}/courses/#{course.course_code}/details"

      expect(course_details_page).not_to have_edit_locations_link
      expect(course_details_page.manage_provider_locations_link).to have_content(
        "Manage all your locations"
      )
    end
  end

  context 'when the course is new and not running' do
    let(:course) do
      build :course,
            sites: [site1, site2],
            provider: provider,
            ucas_status: 'new',
            recruitment_cycle: current_recruitment_cycle
    end

    scenario 'viewing the course details page' do
      visit "/organisations/A0/#{course.recruitment_cycle.year}/courses/#{course.course_code}/details"

      expect(course_details_page.locations).to have_content(
        site1.location_name
      )
      expect(course_details_page.locations).to have_content(
        site2.location_name
      )
    end
  end

  scenario 'viewing the show page for a course that does not exist' do
    stub_api_v2_request(
      "/recruitment_cycles/2019/providers/ZZ/courses/ZZZ?include=sites,provider.sites,accrediting_provider",
      '',
      :get,
      404
    )

    course
    visit "/organisations/ZZ/2019/courses/ZZZ/details"

    expect(course_details_page)
    .to be_displayed(provider_code: 'ZZ', course_code: 'ZZZ')
    expect(course_details_page.title.text).to eq 'Page not found'
  end
end
