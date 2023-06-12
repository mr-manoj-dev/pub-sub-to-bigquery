import json
import random
from datetime import datetime, timedelta
from google.cloud import pubsub_v1


"""
Generate messages
"""
def generate_messages(num_messages):
    first_names = ["John", "Alice", "Michael", "Emma", "David", "Olivia"]
    last_names = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Davis"]

    messages = []

    for i in range(num_messages):
        cust_id = f"C{i+1:03}"
        first_name = random.choice(first_names)
        last_name = random.choice(last_names)
        account_type = random.choice(["CURRENT", "SAVINGS"])
        customer_since = (datetime.now() - timedelta(days=random.randint(0, 365))).strftime("%Y-%m-%d")
        active = random.choice([True, False])

        message = {
            "cust_id": cust_id,
            "first_name": first_name,
            "last_name": last_name,
            "account_type": account_type,
            "customer_since": customer_since,
            "active": active
        }

        messages.append(message)

    return messages


"""
Publish generated messages to pub/sub topic

"""

def publish_messages_from_json(json_file, project_id, topic_name):
    publisher = pubsub_v1.PublisherClient()
    topic_path = publisher.topic_path(project_id, topic_name)

    with open(json_file, 'r') as file:
        messages = json.load(file)

    for message in messages:
        data = json.dumps(message).encode('utf-8')
        future = publisher.publish(topic_path, data)
        future.result()  # Wait for the message to be published

    print('All messages published.')


project_id = 'burner-mankumar24'
topic_name = 'test-topic-1'

# Generate messages
num_messages = 50
messages = generate_messages(num_messages)

# Save messages to a JSON file
json_file_path = 'messages.json'
with open(json_file_path, 'w') as file:
    json.dump(messages, file, indent=2)

print(f"{num_messages} messages generated and saved to '{json_file_path}'.")


publish_messages_from_json(json_file_path, project_id, topic_name)



