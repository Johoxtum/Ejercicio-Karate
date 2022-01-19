Feature: Create Token

Background: precondiciones
    Given url apiUrl

    Scenario: Create Token
        
        Given request
            """
            {
                "user": {
                    "email": "Test13@gmail.com",
                    "password": "Manzana123"
                }
            }
            """
        And   path "users/login"
        When  method Post
        Then  status 200
        * def authToken = response.user.token
        * print authToken
