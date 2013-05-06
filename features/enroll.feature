Feature: Participants can enroll to challenges
        In order to enroll to a challenge
        as an user
        I want to be able to view the challenge and press enroll
        
        
        Background:
          Given the following user records
          | email                           | password | password_confirmation  | role  |
      		| supervisor@student.utwente.nl   | abcd1234 | abcd1234               | 1     |
      		| participant@student.utwente.nl  | abcd1234 | abcd1234               | 0     |
          And the following challenge records
          | id  | title   | description               | start_date        | end_date  | state       | count | user_id |
          | 1   | Title1  | Description1              |                   |           | approved    | 1     | 1       |
          | 2   | Title2  | Description2              |                   |           | pending     | 2     | 1       |
          | 3   | Title3  | Description3              |                   |           | proposal    | 1     | 1       |
          | 4   | Title4  | Description4              |                   |           | proposal    | 4     | 1       |
          | 5   | Title5  | Description5              | 09-09-2009        |           | approved    | 2     | 1       |
          When I visit the "login" page
        	And I fill in email with "participant@student.utwente.nl" and password with "abcd1234"
         
        
        Scenario: View all challenges
          When I visit the "challenges.index" page
          Then I should see a title "Title1" and description "Description1" and start_date "next week" and end_date "1 month after" 
          And I should see a title "Title5" and description "Description5" and start_date "next week" and end_date "1 month after" 
          
        
        Scenario Outline: View a challenge
          When I open the challenge with id "<challenge_id>"
          Then I should see a title "<title>" and description "<description>" and start_date "<date>" and end_date "1 month after" 
          And I should see a button "<buttons>"
        
        Examples:
        | date        |   challenge_id    | title   | description  |  buttons     |
        | before      |   1               | Title1  | Description1 |  enroll      |
        | next week   |   5               | Title5  | Description5 |              |
        
       
        Scenario: Subscribe to a challenge before start date
          When I open the challenge with id "1"
          And I follow "Enroll"
          Then I should see a message with "Successfully enrolled"
         
         @focus
        Scenario: Subscribe to a challenge after start date
          When I open the challenge with id "5"
          Then I should not see button "Enroll"
        
        
        Scenario Outline: Unsubscribe from a challenge
          Given user "participant@student.utwente.nl" is subscribed to challenge "<challenge_id>"
          When I open the challenge with id "<challenge_id>"
          And I follow "Unenroll"
          Then I should see a message with "Successfully unenrolled"
        
        Examples:
        |  challenge_id   |
        |   1             | 
        |   5             |
           
           
        Scenario Outline: View challenge with state
          When I open the challenge with id "<challenge_id>"
          Then I should see the "<redirect>" page
        
        Examples:
        | challenge_id      |  redirect           |
        | 3                 |  challenges.index   |
        | 2                 |  challenges.index   |
        | 4                 |  challenges.index   |
        
        
        