# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Permission.destroy_all
permission = Permission.create!(
    [
        {
            nombre: 'crear_usuario',
            descripcion: 'Para crear usuarios.'
        },{
            nombre: 'crear_consulta',
            descripcion: 'Para crear consultas.'
        }
    ]
)

UserType.destroy_all
userType = UserType.create!(
    [
        {
            nombre: 'sucursal',
            descripcion: 'Tipo de usuario para sucursal.'
        },{
            nombre: 'medico',
            descripcion: 'Tipo de usuario para medico.'
        },{
            nombre: 'administrador',
            descripcion: 'Tipo de usuario para administrador'
        }
    ]
)

UserTypePermission.destroy_all
UserTypePermission.create!(
    [
        {
            permission_id: permission[1].id,
            user_type_id: userType[0].id
        },{
            permission_id: permission[1].id,
            user_type_id: userType[1].id
        },{
            permission_id: permission[0].id,
            user_type_id: userType[2].id
        }
    ]
)

User.destroy_all
User.create!(
    [
        {
            username: 'sistemasadmin',
            password_digest: BCrypt::Password.create('123123123', cost: 5),
            email: 'sistemas@farmaciasmedisim.com',
            nombre: 'Sistemas',
            apellido_paterno: '',
            apellido_materno: '',
            user_type_id: userType[2].id
        }
    ]
)

Category.destroy_all
categories = Category.create!(
    [
        {
            nombre: 'General'
        },{
            nombre: 'Inyeccion'
        }
    ]
)

Service.destroy_all
Service.create!(
    [
        {
            nombre: 'Inyeccion IV',
            descripcion: 'Inyección intravenosa.',
            costo: 40,
            estado: 1,
            category_id: categories[1].id
        },{
            nombre: 'Consulta',
            descripcion: 'Consulta medica.',
            costo: 50,
            estado: 1,
            category_id: categories[0].id
        },{
            nombre: 'Inyeccion IM',
            descripcion: 'Inyección intramuscular.',
            costo: 30,
            estado: 1,
            category_id: categories[1].id
        },{
            nombre: 'Receta de medicamento controlado',
            descripcion: 'Receta de medicamento controlado.',
            costo: 50,
            estado: 1,
            category_id: categories[0].id
        },{
            nombre: 'Certificado',
            descripcion: 'Certificado Médico.',
            costo: 50,
            estado: 1,
            category_id: categories[0].id
        },{
            nombre: 'Justificante',
            descripcion: 'Justificante médico.',
            costo: 50,
            estado: 1,
            category_id: categories[0].id
        }
    ]
)