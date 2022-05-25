# Export Amazon SES Suppression List
I needed to export my Simple Email Service (SES) suppression list from time to time to manually confirm that the unsubscribe/spam/bounce notifications were working and to compare with my own suppression lists.

The current (as of 5/24/2022) version of the AWS console does not provide an export option for the Suppression List, so I made this simple script to export using the AWS CLI client. I decided to publish since there were a others who were seeking to do the same. Use at your own risk.

Tested on OS X 11.6 (Big Sur) and steps will be 

**Dependencies:**

 - [AWS CLI Client](https://aws.amazon.com/cli/) to query the api
 - [Dasel](https://daseldocs.tomwright.me/installation) for parsing the JSON responses in the terminal


**Usage:**

Install the dependencies and make sure to configure and authorize the AWS client using ``aws configure`` and [entering your keys](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).

Create a folder and put the ``fetch.sh`` script in the folder. Navigate to the folder in your terminal and run ``bash fetch.sh`` , ``zsh fetch.sh``  or whatever terminal you prefer. It might not work on other terminals.

The script operates like so:

 1. Create an empty CSV file named ``list.csv``
 2. Query the API for the suppression list
 3. Append to the results to the CSV file
 4. Check if a ``NextToken`` is present [indicating that there are more results](https://docs.aws.amazon.com/ses/latest/dg/sending-email-suppression-list.html#:~:text=Note%20%E2%80%93%20If%20your,parameter%20like%20so:)
 5. If a token is present in the response, repeat steps 2-4.