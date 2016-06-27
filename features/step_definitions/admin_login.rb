假如(/^我有一个管理员账号$/) do
  User.create(name: "管理员", email: "admin@test.com", password: 123456)
end

假如(/^我使用这个管理员账号登录系统$/) do
  visit "/sign_in"
  find("input[type='text']").set("admin@test.com")
  find("input[type='password']").set("123456")
  find(".sign-in-form.ui.form a.ui.button").click
  find("div.right.menu a:nth-child(4)").click
end

那么(/^我进入了后台管理$/) do
  expect(page).to have_css(".manager-sidebar")
end
