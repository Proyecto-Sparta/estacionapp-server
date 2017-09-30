defmodule EstacionappServer.ErrorViewTest do
  use EstacionappServer.ConnCase, async: true

  alias EstacionappServer.{Garage, Driver}

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 400.json" do
    assert render(EstacionappServer.ErrorView, "400.json", [reason: %{message: "Foo"}]) ==
           %{errors: %{detail: "Foo"}}
  end

  test "renders 401.json" do
    assert render(EstacionappServer.ErrorView, "401.json", [reason: %{message: "Foo"}]) ==
           %{errors: %{detail: "Foo"}}
  end

  test "renders 404.json" do
    assert render(EstacionappServer.ErrorView, "404.json", []) ==
           %{errors: %{detail: "Page not found"}}
  end

  test "renders 422.json of a garage" do
    changeset = Garage.changeset(%Garage{})
    assert render(EstacionappServer.ErrorView, "422.json", [reason: %{changeset: changeset}]) ==
           %{errors: %{detail: %{email: ["can't be blank"], 
                                 name: ["can't be blank"], 
                                 location: ["can't be blank"], 
                                 password: ["can't be blank"], 
                                 username: ["can't be blank"]}}}
  end

  test "renders 422.json of a driver" do
    changeset = Driver.changeset(%Driver{})
    assert render(EstacionappServer.ErrorView, "422.json", [reason: %{changeset: changeset}]) ==
           %{errors: %{detail: %{email: ["can't be blank"], 
                                 full_name: ["can't be blank"],                                   
                                 password: ["can't be blank"], 
                                 username: ["can't be blank"]}}}
  end

  test "render 500.json" do
    assert render(EstacionappServer.ErrorView, "500.json", []) ==
           %{errors: %{detail: "Internal server error"}}
  end

  test "render any other" do
    assert render(EstacionappServer.ErrorView, "505.json", []) ==
           %{errors: %{detail: "Internal server error"}}
  end
end
