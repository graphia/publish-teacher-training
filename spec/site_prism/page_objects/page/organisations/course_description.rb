module PageObjects
  module Page
    module Organisations
      class CourseDescription < CourseBase
        set_url '/organisations/{provider_code}/courses/{course_code}/description'

        element :about, '[data-qa=course__about_course]'
        element :interview_process, '[data-qa=course__interview_process]'
        element :placements_info, '[data-qa=course__how_school_placements_work]'
        element :length, '[data-qa=course__course_length]'
        element :salary, '[data-qa=course__salary_details]'
        element :uk_fees, '[data-qa=course__fee_uk_eu]'
        element :international_fees, '[data-qa=course__international_fees]'
        element :fee_details, '[data-qa=course__fee_details]'
        element :financial_support, '[data-qa=course__financial_support]'
        element :required_qualifications, '[data-qa=course__qualifications]'
        element :personal_qualities, '[data-qa=course__personal_qualities]'
        element :other_requirements, '[data-qa=course__other_requirements]'
        element :has_vacancies, '[data-qa=course__has_vacancies]'
        element :is_findable, '[data-qa=course__is_findable]'
        element :open_for_applications, '[data-qa=course__open_for_applications]'
        element :last_published_at, '[data-qa=course__last_published_date]'
        element :status_tag, '[data-qa=course__content-status]'
        element :preview_link, '[data-qa=course__preview-link]'
        element :publish, '[data-qa=course__publish]'
        element :success_summary, '.govuk-success-summary'
        element :error_summary, '.govuk-error-summary'
        element :status_panel, '[data-qa=course__status_panel]'
      end
    end
  end
end
