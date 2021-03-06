Feature: Remove a book administratively
  As an administrator
  In order to remove information for a book for which the author does not have a user account
  I need to be able to delete the book

  Scenario: An administrator deletes a book
    Given there is an author named "George Orwell"
    And author "George Orwell" has a bio
    And author "George Orwell" has a book titled "Nineteen Eighty Four"
    And there is an administrator with email "joe@admin.com" and password "please01"

    When I am signed in as an administrator with "joe@admin.com/please01"
    And I am on the administration home page
    Then I should see "Authors" within the main menu

    When I click "Authors" within the main menu
    Then I should see "Authors" within the page title
    And I should see the following authors table
      | Last name | First name |
      | Orwell    | George     |

    When I click the books button within the 1st author row
    Then I should see "Books for George Orwell" within the page title
    And I should see the following books table
      | Title                |
      | Nineteen Eighty Four |

    When I click the delete button within the 1st book row
    Then I should see "The book was removed successfully" within the notification area
    And I should see "Books for George Orwell" within the page title
    And I should see the following books table
      | Title |
