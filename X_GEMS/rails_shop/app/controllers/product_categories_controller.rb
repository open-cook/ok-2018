class ProductCategoriesController < RailsShopController
  include RailsShop::MainImageActions

  before_action :authenticate_user!,  except: %w[ index show ]
  before_action :shop_admin_required, except: %w[ index show ]

  before_action :set_product_category, only: [:show]
  before_action :set_editable_product_category, only: [:edit, :update, :destroy]

  before_action :set_holder_for_main_image, only: RailsShop::MainImageActions::ACTIONS

  def show
    @products = @product_category.products.published.in_stock.max2min(:created_at).pagination(params)
  end

  # RESTRICTED AREA

  def manage
    @product_categories = ProductCategory.for_manage.pagination(params)
  end

  def new
    @product_category = ProductCategory.new
  end

  def edit; end

  def create
    @product_category = current_user.product_categories.new(product_category_params)

    if @product_category.save
      redirect_to url_for([:edit, @product_category]), notice: 'Категория товаров успешно создана'
    else
      render action: 'new'
    end
  end

  def update
    if @product_category.update(product_category_params)
      redirect_to url_for([:edit, @product_category]), notice: 'Категория товаров успешно обновлена'
    else
      render action: 'edit'
    end
  end

  def destroy
    @product_category.destroy
    redirect_to products_url
  end

  private

  def set_product_category
    @product_category = ProductCategory.published.friendly_first(params[:id])
    return page_404 unless @product_category
  end

  def set_editable_product_category
    @product_category = ProductCategory.for_manage.friendly_first(params[:id])
    return page_404 unless @product_category
  end

  def set_holder_for_main_image
    @main_image_holder = @product_category
  end

  def product_category_params
    params.require(:product_category).permit(
      :title,
      :state
    )
  end
end
