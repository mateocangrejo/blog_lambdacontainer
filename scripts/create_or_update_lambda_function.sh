echo "This is the image tag to be used: $SHA"
if aws lambda get-function --function-name container-lambda; then
  echo "Updating Lambda function code..."
  aws lambda update-function-code --function-name container-lambda \
    --image-uri 300903264828.dkr.ecr.us-east-2.amazonaws.com/lambda-from-container-image:$SHA
else
  echo "Creating new Lambda function 'container-lambda'..."
  aws lambda create-function --function-name container-lambda \
    --package-type Image \
    --code ImageUri=300903264828.dkr.ecr.us-east-2.amazonaws.com/lambda-from-container-image:$SHA \
    --role arn:aws:iam::300903264828:role/lambda-execution-role \
    --environment Variables="{NUMPY_ARRAY='[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]'}" \
    --region us-east-2
fi