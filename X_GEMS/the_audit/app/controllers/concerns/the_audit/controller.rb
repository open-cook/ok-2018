module TheAudit
  module Controller
    extend ActiveSupport::Concern

    included do
      before_action :set_audit, only: %w[ show edit update destroy ]
    end

    def index
      @ctrl_acts = Audit
        .audit_scope(params)
        .select('DISTINCT controller_name, action_name, COUNT(*) as count')
        .group('controller_name, action_name')
        .reorder('count DESC').to_a

      @audits_count = Audit.audit_scope(params).count
      @audits = Audit.audit_scope(params).pagination(params)
    end

    def show; end

    def edit; end

    def update
      if @audit.update(audit_params)
        redirect_to audit_path(@audit), notice: 'Audit was successfully updated.'
      else
        render action: 'edit'
      end
    end

    def destroy
      @audit.destroy
      redirect_to audits_url
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_audit
      @audit = Audit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def audit_params
      params.require(:audit).permit(:user_id, :obj_id, :obj_type, :controller_name, :action_name, :ip, :remote_ip, :fullpath, :referer, :user_agent, :remote_addr, :remote_host, :data)
    end
  end
end
