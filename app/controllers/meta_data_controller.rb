class MetaDataController < ApplicationController
  layout 'bootstrap_default'

  before_action :user_require
  before_action :admin_require
  before_action :set_meta_data,  only: %w[ edit update ]

  def index
    @meta_datum = MetaData.simple_sort(params, :updated_at).pagination(params)
  end

  def edit; end

  def update
    @meta_data.update(meta_data_params)
    redirect_path = params[:redirect_path] || url_for([:edit, @meta_data])
    redirect_to redirect_path, notice: "Мета Данные установлены"
  end

  private

  def set_meta_data
    @meta_data = MetaData.find params[:id]
    @holder = @meta_data.holder

    @owner_check_object = @meta_data
  end

  def meta_data_params
    params.require(:meta_data).permit(%w[
      title keywords description author
      og_url og_type og_image og_title og_description og_site_name
    ])
  end
end
