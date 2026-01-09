aws iam create-role \
--role-name containerlambdacicd-codebuild-role \
--assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "codebuild.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}'


aws iam put-role-policy \
--role-name containerlambdacicd-codebuild-role \
--policy-name containerlambdacicd-codebuild-inline-policy \
--policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ecr:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutCodeCoverages",
                "codebuild:BatchPutTestCases"
            ],
            "Resource": "arn:aws:codebuild:us-east-2:300903264828:report-group/MyLambdaBuildProject-*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::300903264828:role/lambda-execution-role"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:us-east-2:300903264828:log-group:/aws/codebuild/MyLambdaBuildProject",
                "arn:aws:logs:us-east-2:300903264828:log-group:/aws/codebuild/MyLambdaBuildProject:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "lambda:*",
            "Resource": "arn:aws:lambda:us-east-2:300903264828:function:container-lambda"
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::containerlambdacicd-blog-artifacts-mateocangrejo",
                "arn:aws:s3:::containerlambdacicd-blog-artifacts-mateocangrejo/*"
            ]
        }
    ]
}'


aws iam create-role \
--role-name containerlambdacicd-codepipeline-role \
--assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codepipeline.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}'


aws iam put-role-policy \
--role-name containerlambdacicd-codepipeline-role \
--policy-name containerlambdacicd-codepipeline-inline-policy \
--policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:StartBuild",
                "codebuild:BatchGetBuilds"
            ],
            "Resource": "arn:aws:codebuild:us-east-2:300903264828:project/MyLambdaBuildProject"
        },
        {
            "Effect": "Allow",
            "Action": [
                "codestar-connections:UseConnection"
            ],
            "Resource": "arn:aws:codeconnections:us-east-2:300903264828:connection/b5893d6c-762e-44cc-a42a-c9c3618fd8bf"
        },
        {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::containerlambdacicd-blog-artifacts-mateocangrejo/*"
        }
    ]
}'



# Create the Lambda execution role and attach AWSLambdaBasicExecutionRole policy
aws iam create-role \
--role-name lambda-execution-role \
--assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}'

# Attach the AWSLambdaBasicExecutionRole managed policy to the Lambda execution role
aws iam attach-role-policy \
--role-name lambda-execution-role \
--policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
