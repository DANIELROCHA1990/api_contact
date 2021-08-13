class Api::V1::ContactsController < Api::V1::ApiController
  before_action :set_contact, only: %i[show update destroy] # seta o id
  before_action :require_authentication!, only: %i[show update destroy] # autoriza o que o usuario pode fazer
  # Get /api/v1/contacts

  def index
    @contacts = current_user.contacts

    render json: @contacts
  end

  # Get /api/v1/contacts/1
  def show
    render json: @contact
  end

  # Get /api/v1/contacts/1
  def create
    @contact = Contact.new(contact_params.merge(user: current_user)) # quando criar ja mostra o id

    if @contact.save
      render json: @contact, status: :created
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/contacts/1
  def update
    if @contact.update(contact_params)
      render json: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/contacts/1
  def destroy
    @contact.destroy
  end

  private

  # Use callback to share commom setup or constrains between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:name, :email, :phone, :description)
  end

  def require_authentication!
    unless current_user == @contact.user
      render json {}, status: :forbiden
    end
  end
end
