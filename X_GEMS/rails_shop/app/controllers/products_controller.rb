class ProductsController < RailsShopController
  include RailsShop::MainImageActions

  before_action :authenticate_user!,  except: %w[ index show ]
  before_action :shop_admin_required, except: %w[ index show ]

  before_action :set_product, only: [:show, :edit, :update, :destroy] + RailsShop::MainImageActions::ACTIONS
  before_action :set_holder_for_main_image, only: RailsShop::MainImageActions::ACTIONS

  def index
    @products = Product.published.in_stock.max2min(:created_at).pagination(params)
  end

  def show; end

  # RESTRICTED AREA

  def realtion_category
    action   = params[:relation_action].to_s
    product  = Product.friendly_first(params[:id])
    category = ProductCategory.friendly_first(params[:category_id])

    if action == 'true'
      rel = ProductCategoryRelation.create(
        product_id:          product.id,
        product_category_id: category.id
      )
    else
      rel = ProductCategoryRelation.where(
        product_id:          product.id,
        product_category_id: category.id
      ).first

      rel.destroy!
    end

    render json: {
      params: {
        action: action,
        p:      product.id,
        c:      category.id,
        rel:    rel.id
      }
    }
  end

  def manage
    @products = Product.recent.simple_sort(params).pagination(params)
  end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = current_user.products.new(product_params)
    @product.content_processing_for(current_user)

    if @product.save
      redirect_to url_for([:edit, @product]), notice: 'Товар успешно создан'
    else
      render action: 'new'
    end
  end

  def update
    @product.assign_attributes(product_params)
    @product.content_processing_for(current_user)

    if @product.save
      redirect_to url_for([:edit, @product]), notice: 'Товар успешно обновлен'
    else
      render action: 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to :back, notice: 'Товар удален'
  end

  private

  def set_product
    @product = Product.friendly_first(params[:id])
  end

  def set_holder_for_main_image
    @main_image_holder = @product
  end

  def product_params
    params.require(:product).permit(
      :main_image,

      :title,
      :raw_intro,
      :raw_content,

      :state,

      :sku,
      :price,
      :price_text,
      :discount,
      :amount,
      :equipment,
      :weight,
      :dimensions,
      :special_marker
    )
  end
end
