module Organizations::LabsHelper
  def improve_approval_application_default_value(lab)
    %{
        Hi #{lab.creator.first_name},
        more information were requested for your lab #{lab}. This means that either the platform admins, or the designated referees would like to know more about your lab.

        Please add more information to the slug and description fields of the lab form so that we can learn more about your Fablab. -

        You can check your lab profile at:
        #{lab_url(lab)}

        If you have questions regarding the approval process for fablabs, you can check the following doc:
        "http://www.fablabs.io/labs/docs/approval_process"
      }
  end
end
