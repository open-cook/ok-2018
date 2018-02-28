module UsersBuild
  class << self
    def create_admin!
      TheRole.create_admin_role!
      User.create_admin!

      puts "First User (admin) created"
      puts "Login: [admin], Password: [qwerty]"
      puts '~'*40
    end

    def first_user!
      TheRole.create_admin_role!

      User.create!(
        login: :mrs_home,
        username: "Анна Нечаева",
        email: "admin@open-cook.ru",
        password: "vbh,eltnyfi",
        role: Role.with_name(:admin)
      )
    end
  end
end
