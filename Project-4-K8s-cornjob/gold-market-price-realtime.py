import os
import json
import logging
import time
import boto3
import requests
from botocore.exceptions import BotoCoreError, ClientError

# ✅ Logging setup
logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')

# ✅ Load environment variable safely
ACCESS_TOKEN = os.environ.get('GOLD_API_ACCESS_TOKEN')
if not ACCESS_TOKEN:
    logging.error("Missing GOLD_API_ACCESS_TOKEN environment variable")
    raise SystemExit

API_URL = "https://www.goldapi.io/api/XAU/USD"
HEADERS = {"x-access-token": ACCESS_TOKEN}
MAX_RETRIES = 3
RETRY_DELAY = 2  # seconds

def get_gold_prices():
    """Fetch gold prices from GoldAPI with retries and validation."""
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            response = requests.get(API_URL, headers=HEADERS, timeout=10)
            response.raise_for_status()

            data = response.json()

            required_keys = [
                "price_gram_24k", "price_gram_22k", "price_gram_21k",
                "price_gram_20k", "price_gram_18k", "price_gram_16k",
                "price_gram_14k", "price_gram_10k"
            ]

            if not all(key in data for key in required_keys):
                raise KeyError("Missing expected gold price fields in API response")

            logging.info("Successfully fetched gold prices")
            return data

        except (requests.exceptions.RequestException, ValueError, KeyError) as e:
            logging.warning(f"Attempt {attempt}/{MAX_RETRIES} failed: {e}")

            if attempt == MAX_RETRIES:
                logging.error("All retries exhausted — exiting")
                raise

            time.sleep(RETRY_DELAY)


def publish_to_sns(message):
    """Publish formatted gold price data to SNS topic."""
    try:
        sns_client = boto3.client("sns")
        response = sns_client.publish(
            TopicArn='arn:aws:sns:us-east-1:556885871565:gold-price',
            Message=message,
            Subject='Indian Gold Market Prices'
        )
        status = response.get("ResponseMetadata", {}).get("HTTPStatusCode")

        if status == 200:
            logging.info("SNS Notification Sent Successfully.")
        else:
            logging.error(f"SNS returned unexpected status: {status}")

    except (ClientError, BotoCoreError) as e:
        logging.error(f"SNS Publish Failed: {e}")
        raise


# ✅ Main execution
try:
    gold_data = get_gold_prices()

    result = "\n".join([
        f"24K Gold: {gold_data['price_gram_24k']}",
        f"22K Gold: {gold_data['price_gram_22k']}",
        f"21K Gold: {gold_data['price_gram_21k']}",
        f"20K Gold: {gold_data['price_gram_20k']}",
        f"18K Gold: {gold_data['price_gram_18k']}",
        f"16K Gold: {gold_data['price_gram_16k']}",
        f"14K Gold: {gold_data['price_gram_14k']}",
        f"10K Gold: {gold_data['price_gram_10k']}",
    ])

    publish_to_sns(result)

except Exception as e:
    logging.critical(f"Script failed: {e}")
