import boto3


def main() -> None:
    """
    Very basic application that reads data from a hard-coded bucket, prints what is in there and writes a new file back
    to the same bucket. It's print statement only serve as checks whether the output arrives at the CloudFormation logs.
    """

    DATA_BUCKET = "serverless-batch-data-bucket"

    print("Step One: a message from within the container.")

    s3 = boto3.resource("s3")
    bucket = s3.Bucket(DATA_BUCKET)

    print(f"Step Two: let's look into {DATA_BUCKET} and see what is in there.")

    for obj in bucket.objects.all():
        key = obj.key
        body = obj.get()['Body'].read()
        print(f"{key} holds {body}.")

    print("Step Three: let's try to write a file into the bucket.")

    content = "This is the new stuff we want to see in a new file."
    s3.Object(DATA_BUCKET, "new_file.txt").put(Body=content)


if __name__ == "__main__":
    main()
