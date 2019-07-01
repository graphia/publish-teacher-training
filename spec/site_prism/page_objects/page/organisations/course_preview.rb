module PageObjects
  module Page
    module Organisations
      class CoursePreview < PageObjects::Base
        set_url '/organisations/{provider_code}/{recruitment_cycle_year}/courses/{course_code}/preview'

        element :sub_title, '[data-qa=course__provider_name]'
        element :description, '[data-qa=course__description]'
        element :accredited_body, '[data-qa=course__accredited_body]'
        element :qualifications, '[data-qa=course__qualifications]'
        element :funding_option, '[data-qa=course__funding_option]'
        element :length, '[data-qa=course__length]'
        element :applications_open_from, '[data-qa=course__applications_open]'
        element :start_date, '[data-qa=course__start_date]'
        element :provider_website, '[data-qa=course__provider_website]'
        element :vacancies, '[data-qa=course__vacancies]'
        element :about_course, '#section-about'
        element :interview_process, '[data-qa=course__interview_process]'
        element :school_placements, '#section-schools'
        element :uk_fees, '[data-qa=course__uk_fees]'
        element :eu_fees, '[data-qa=course__eu_fees]'
        element :fee_details, '[data-qa=course__fee_details]'
        element :international_fees, '[data-qa=course__international_fees]'
        element :salary_details, '#section-salary'
        element :scholarship_amount, '[data-qa=course__scholarship_amount]'
        element :bursary_amount, '[data-qa=course__bursary_amount]'
        element :required_qualifications, '[data-qa=course__required_qualifications]'
        element :personal_qualities, '[data-qa=course__personal_qualities]'
        element :other_requirements, '[data-qa=course__other_requirements]'
        element :train_with_us, '#section-about-provider'
        element :about_accrediting_body, '[data-qa=course__about_accrediting_body]'
        element :train_with_disability, '#section-train-with-disabilities'
        element :contact_email, '[data-qa=provider__email]'
        element :contact_telephone, '[data-qa=provider__telephone]'
        element :contact_website, '[data-qa=provider__website]'
        element :contact_address, '[data-qa=provider__address]'
        element :course_advice, '#section-advice'
        element :course_apply, '#section-apply'
        element :choose_a_training_location_table, '[data-qa=course__choose_a_training_location]'
      end
    end
  end
end
