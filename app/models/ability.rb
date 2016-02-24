class Ability
  include CanCan::Ability

  def initialize(author)
    author ||= Author.new
    can [:show, :update, :edit], Author, id: author.id
    can [:create, :show, :update, :edit], Bio, author_id: author.id
    can :show, Image do |image|
      image.can_be_viewed_by?(author)
    end
    can :show, BookVersion do |book_version|
      book_version.approved? || book_version.book.author_id == author.id
    end
    can [:version, :update, :create], Book, author_id: author.id
    can [:update, :edit], BookVersion do |book_version|
      book_version.book.author_id == author.id && book_version.pending?
    end
  end
end
