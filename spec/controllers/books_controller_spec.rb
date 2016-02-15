require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let (:author) { FactoryGirl.create(:author) }
  let (:pending_book) { FactoryGirl.create(:pending_book, author: author) }
  let (:approved_book) { FactoryGirl.create(:approved_book, author: author) }
  let (:rejected_book) { FactoryGirl.create(:rejected_book, author: author) }
  let (:book_attributes) { FactoryGirl.attributes_for(:book, author: author) }

  context 'for an authenticated author' do
    before(:each) { sign_in author }

    describe 'get :index' do
      it 'is successful' do
        get :index, author_id: author
        expect(response).to have_http_status :success
      end
    end

    describe 'get :new' do
      it 'is successful' do
        get :new, author_id: author
        expect(response).to have_http_status :success
      end
    end

    describe 'post :create' do
      it 'redirects to the book page' do
        post :create, author_id: author, book: book_attributes
        expect(response).to redirect_to book_path(Book.last)
      end

      it 'creates a new book record' do
        expect do
          post :create, author_id: author, book: book_attributes
        end.to change(Book, :count).by(1)
      end
    end

    context 'that owns the book' do
      context 'that is pending approval' do
        describe 'get :show' do
          it 'is successful' do
            get :show, id: pending_book
            expect(response).to have_http_status :success
          end
        end

        describe 'get :edit' do
          it 'is successful' do
            get :edit, id: pending_book
            expect(response).to have_http_status :success
          end
        end

        describe 'patch :update' do
          it 'redirects to the book page' do
            patch :update, id: pending_book, book: book_attributes
            expect(response).to redirect_to book_path(pending_book)
          end

          it 'updates the book' do
            expect do
              patch :update, id: pending_book, book: book_attributes.merge(title: 'The new title')
              pending_book.reload
            end.to change(pending_book, :title).to('The new title')
          end
        end
      end
      context 'that is approved' do
        describe 'get :show' do
          it 'is successful' do
            get :show, id: approved_book
            expect(response).to have_http_status :success
          end
        end

        describe 'get :edit' do
          it 'redirects to the home page' do
            get :edit, id: approved_book
            expect(response).to redirect_to author_root_path
          end
        end

        describe 'patch :update' do
          it 'redirects to the home page' do
            patch :update, id: approved_book, book: book_attributes
            expect(response).to redirect_to author_root_path
          end

          it 'updates the book' do
            expect do
              patch :update, id: approved_book, book: book_attributes.merge(title: 'The new title')
              approved_book.reload
            end.not_to change(approved_book, :title)
          end
        end
      end
      context 'that is rejected' do
        describe 'get :show' do
          it 'is successful' do
            get :show, id: rejected_book
            expect(response).to have_http_status :success
          end
        end

        describe 'get :edit' do
          it 'redirects to the home page' do
            get :edit, id: rejected_book
            expect(response).to redirect_to author_root_path
          end
        end

        describe 'patch :update' do
          it 'redirects to the home page' do
            patch :update, id: rejected_book, book: book_attributes
            expect(response).to redirect_to author_root_path
          end

          it 'updates the book' do
            expect do
              patch :update, id: rejected_book, book: book_attributes.merge(title: 'New title')
              rejected_book.reload
            end.not_to change(rejected_book, :title)
          end
        end
      end
    end

    context 'that does not own the book' do
      let (:other_author) { FactoryGirl.create(:approved_author) }
      before(:each) { sign_in other_author }

      context 'that is pending approval' do
        describe 'get :show' do
          it 'redirects to the home page' do
            get :show, id: pending_book
            expect(response).to redirect_to author_root_path
          end
        end

        describe 'get :edit' do
          it 'redirects to the home page' do
            get :edit, id: pending_book
            expect(response).to redirect_to author_root_path
          end
        end

        describe 'patch :update' do
          it 'redirects to the home page' do
            patch :update, id: pending_book, book: book_attributes
            expect(response).to redirect_to author_root_path
          end

          it 'does not update the book' do
            expect do
              patch :update, id: pending_book, book: book_attributes.merge(title: 'The new title')
              pending_book.reload
            end.not_to change(pending_book, :title)
          end
        end
      end

      context 'that is approved' do
        describe 'get :show' do
          it 'is successful'
        end

        describe 'get :edit' do
          it 'redirects to the home page'
        end

        describe 'patch :update' do
          it 'redirects to the home page'
          it 'does not update the book'
        end
      end

      context 'that is rejected' do
        describe 'get :show' do
          it 'redirects to the home page'
        end

        describe 'get :edit' do
          it 'redirects to the home page'
        end

        describe 'patch :update' do
          it 'redirects to the home page'
          it 'does not update the book'
        end
      end
    end
  end

  context 'for an authenticated administrator' do
    describe 'get :index' do
      it 'is successful'
    end

    describe 'get :new' do
      it 'redirects to the home page'
    end

    describe 'post :create' do
      it 'redirects to the home page'
      it 'does not create a book record'
    end

    describe 'get :show' do
      context 'for book pending approval' do
        describe 'get :show' do
          it 'is successful'
        end

        describe 'get :edit' do
          it 'redirects to the home page'
        end

        describe 'patch :update' do
          it 'redirects to the home page'
          it 'does not update the book'
        end
      end

      context 'for a book that is approved' do
        describe 'get :show' do
          it 'is successful'
        end

        describe 'get :edit' do
          it 'redirects to the home page'
        end

        describe 'patch :update' do
          it 'redirects to the home page'
          it 'does not update the book'
        end
      end

      context 'for a book that is rejected' do
        describe 'get :show' do
          it 'is successful'
        end

        describe 'get :edit' do
          it 'redirects to the home page'
        end

        describe 'patch :update' do
          it 'redirects to the home page'
          it 'does not update the book'
        end
      end
    end
  end

  context 'for an unauthenticated user' do
    describe "get #index" do
      it "is successful" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "get #show" do
      it "is successful" do
        get :show
        expect(response).to have_http_status(:success)
      end
    end

    describe "get #new" do
      it "redirects to the author sign in page" do
        get :new
        expect(response).to redirect_to new_author_session_path
      end
    end

    describe "post #create" do
      it "redirects to the author sign in page" do
        post :create
        expect(response).to redirect_to new_author_session_path
      end
      it 'does not create a book record'
    end

    describe "get #edit" do
      it "redirects to the author sign in page" do
        get :edit
        expect(response).to redirect_to new_author_session_path
      end
    end

    describe "patch #update" do
      it "redirects to the author sign in page" do
        patch :update
        expect(response).to redirect_to new_author_session_path
      end
      it 'does not update the book record'
    end
  end
end
