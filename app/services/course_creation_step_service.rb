class CourseCreationStepService
  def execute(current_step:, course:)
    workflow_steps = get_workflow_steps(course)

    {
      next: get_next_step(workflow_steps, current_step),
      previous: get_previous_step(workflow_steps, current_step),
    }
  end

  def get_next_step(steps, current_step)
    next_step_index = steps.find_index(current_step).next
    steps[next_step_index]
  end

  def get_previous_step(steps, current_step)
    previous_step_index = steps.find_index(current_step).pred
    steps[previous_step_index]
  end

  def get_workflow_steps(course)
    if course.is_further_education?
      further_education_workflow_steps
    elsif course.is_uni_or_scitt?
      uni_or_scitt_workflow_steps
    elsif course.is_school_direct?
      school_direct_workflow_steps
    end
  end

  def school_direct_workflow_steps
    %i[
      level
      subjects
      modern_languages
      age_range
      outcome
      fee_or_salary
      full_or_part_time
      location
      accredited_body
      entry_requirements
      applications_open
      start_date
      confirmation
    ]
  end

  def uni_or_scitt_workflow_steps
    %i[
      level
      subjects
      modern_languages
      age_range
      outcome
      apprenticeship
      full_or_part_time
      location
      entry_requirements
      applications_open
      start_date
      confirmation
    ]
  end

  def further_education_workflow_steps
    %i[
      level
      outcome
      full_or_part_time
      location
      applications_open
      start_date
      confirmation
    ]
  end
end
