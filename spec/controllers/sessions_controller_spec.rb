require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe "GET signout" do
    it "redirects the user to DfE Sign-in's session end endpoint" do
      @request.session["auth_user"] = {
        "credentials" => {
          "id_token" => "123"
        }
      }

      get :signout

      expect(subject).to redirect_to("https://signin-test-oidc-as.azurewebsites.net/session/end?id_token_hint=123&post_logout_redirect_uri=https://localhost:3000/auth/dfe/signout")
    end
  end

  describe "GET create" do
    let(:user_info) {
      {
        id: user_id,
        first_name: "John",
        last_name: "Smith",
        email: "email@example.com",
      }
    }
    let(:user) { jsonapi :user, **user_info }
    let(:user_id) { '101' }
    let(:sign_in_user_id) { SecureRandom.uuid }

    before do
      @request.env["omniauth.auth"] = {
        "info" => user.attributes,
        'uid' => sign_in_user_id
      }
    end

    context "if session creation succeeds" do
      before do
        allow(Session).to receive(:create)
          .with(first_name: user.first_name, last_name: user.last_name)
          .and_return(user.to_resource)
        allow(Base).to receive(:connection)
      end

      it "creates the session and redirects to root" do
        get :create

        expect(subject).to redirect_to("/")
        expect(@request.session[:auth_user]['user_id']).to eq user_id
        expect(@request.session[:auth_user]["info"]).to eq user.attributes
      end

      describe 'sentry contexts' do
        before do
          allow(Raven).to receive(:user_context)
          allow(Raven).to receive(:tags_context)
        end

        it 'sets the user id' do
          get :create

          expect(Raven).to have_received(:user_context).with(id: user_id)
        end

        it 'sets the DFE sign-in id in the tags context' do
          get :create

          expect(Raven).to have_received(:tags_context)
                             .with(sign_in_user_id: sign_in_user_id)
        end
      end
    end

    context "if session creation fails" do
      before do
        allow(Session).to receive(:create)
          .and_raise(JsonApiClient::Errors::NotAuthorized, "not authorised")
        allow(Base).to receive(:connection)
      end

      it "redirects to Manage UI root" do
        get :create

        expect(subject).to redirect_to(Settings.manage_ui.base_url)
      end
    end

    context "if user has not accepted terms and conditions" do
      before do
        allow(Session).to receive(:create)
          .and_raise(JsonApiClient::Errors::AccessDenied, "forbidden")
        allow(Base).to receive(:connection)
      end

      it "redirects to Manage UI root" do
        get :create

        expect(subject).to redirect_to(Settings.manage_ui.base_url)
      end
    end
  end

  describe "GET destroy" do
    it "destroys the session and redirects to root" do
      @request.session["auth_user"] = {
        "credentials" => {
          "id_token" => "123"
        }
      }

      get :destroy

      expect(subject).to redirect_to("/")
      expect(@request.session).to be_empty
    end
  end

  # Omniauth documentation says that any authentication failure with the provider
  # will be caught and routed to /auth/failure: https://github.com/omniauth/omniauth/wiki
  describe "GET failure" do
    it "redirects to a 401 page" do
      get :failure

      expect(response.status).to redirect_to("/401")
    end
  end
end
