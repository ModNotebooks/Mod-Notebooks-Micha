class Partner::UploadsController < Partner::BaseController
  respond_to :json

  def form
    uploader = DirectNotebookPDFUploader.new(Notebook.new, :pdf)
    uploader.success_action_status = '201'

    respond_to do |f|
      f.json {
        render json: {
          action: uploader.direct_fog_url,
          utf8: '',
          key: uploader.key,
          acl: uploader.acl,
          AWSAccessKeyId:  uploader.aws_access_key_id,
          success_action_status: uploader.success_action_status,
          policy: uploader.policy,
          signature: uploader.signature
        }
      }
    end
  end

end
