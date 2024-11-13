
def handler(event, context):
    print("Sending email to: " + event['email'])
    return event['email']
    