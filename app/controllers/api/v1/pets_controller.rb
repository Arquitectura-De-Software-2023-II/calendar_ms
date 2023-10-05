#require_relative '.\clients_controller.rb'

class Api::V1::PetsController < ApplicationController
  def index
    pet = Pet.all
    render json: pet, status:200
  end
  def show
    pet = Pet.find_by(pet_id: params[:id])
    if pet
      render json: pet, status: 200
    else
      render json: { error: 'No se encontró o no existe el registro de la mascota' }
    end
  end

  def create
    request_data = JSON.parse(params['_json'])

    owner = Client.find_by(user_id: request_data['user_id'])
    pet = Pet.find_by(pet_id: request_data['pet_id'])
    if owner
      if !pet
        pet = Pet.new(
          # pet_id: pet_params[:pet_id],
          # user_id: pet_params[:user_id]
          pet_id: request_data['pet_id'],
          user_id: request_data['user_id']
        )
        if pet.save
          render json: { error: 'Mascota agregada correctamente al calendario' }, status: 200
        else
          render json: { error: 'No se pudo crear el registro de la mascota' }
        end
      else
        render json: { error: 'La mascota ya existe' }
      end
    else
      render json: { error: 'El dueño de la mascota no existe' }
    end
  end
  def update
    request_data = JSON.parse(params['_json'])
    owner = Client.find_by(user_id: request_data['user_id'])
    pet = Pet.find_by(pet_id: params[:id])
    if pet
      if owner
        if pet.update(
          # pet_id: pet_params[:pet_id],
          # user_id: pet_params[:user_id])
          pet_id: request_data['pet_id'],
          user_id: request_data['user_id'])
          render json: {error:"Datos de la mascota actualizados"}, status: 200
        else
          render json: { error: 'No se pudo actualizar el registro de la mascota' }
        end
      else
        render json: { error: 'El dueño de la mascota actualizada no existe' }
      end
    else
      render json: { error: 'No se encontró esa mascota' }
    end
  end

  def destroy
    pet = Pet.find_by(pet_id: params[:id])
    if pet
      pet.destroy
      render json: { message: 'Registro de mascota eliminado correctamente' }, status: 200
    else
      render json: { error: 'Ese registro de mascota no existe o ya fue eliminado' }
    end
  end

  private
  
    def pet_params
      params.require(:pet).permit(:pet_id, :user_id)
    end
end
