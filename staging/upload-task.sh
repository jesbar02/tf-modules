#!/bin/bash

options=("provider-portal" "marketing-backend" "marketing-frontend" "success" "therapist-signup" \
         "patient-self-report" "forms" "marketplace" "edge")
clear

PS3="Select action 1-${#options[@]} : "
select opt in "${options[@]}"
do
    echo " "
    case $opt in
        "provider-portal")
        for SERVICE_NAME in provider-portal-resque-worker provider-portal-scheduler-worker \
            provider-portal-service
        do
            echo "Service Name: $SERVICE_NAME"
            if [ $(echo $SERVICE_NAME | grep resque) ]
            then
                terraform output provider-portal-resque-worker-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/provider-portal/resque-task-definition/task.json
                rm task.json
            elif [ $(echo $SERVICE_NAME | grep scheduler) ]
            then
                terraform output provider-portal-scheduler-worker-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/provider-portal/scheduler-task-definition/task.json
                rm task.json
            else
                terraform output provider-portal-service-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/provider-portal/service-task-definition/task.json
                rm task.json
            fi
        done
        break
        ;;
        "marketing-backend")
        echo "Service Name: marketing-backend"
        terraform output marketing-backend-service-task-definition-json > task.json
        aws s3 cp task.json s3://luna-staging-custom/marketing-backend/service-task-definition/task.json
        rm task.json
        break
        ;;
        "marketing-frontend")
        echo "Service Name: marketing-frontend"
        terraform output marketing-frontend-service-task-definition-json > task.json
        aws s3 cp task.json s3://luna-staging-custom/marketing-frontend/service-task-definition/task.json
        rm task.json
        break
        ;;
        "success")
        echo "Service Name: success"
        terraform output success-service-task-definition-json > task.json
        aws s3 cp task.json s3://luna-staging-custom/success/service-task-definition/task.json
        rm task.json
        break
        ;;
        "therapist-signup")
        for SERVICE_NAME in therapist-signup-resque-worker therapist-signup-service
        do
            echo "Service Name: $SERVICE_NAME"
            if [ $(echo $SERVICE_NAME | grep resque) ]
            then
                terraform output therapist-signup-resque-worker-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/therapist-signup/resque-task-definition/task.json
                rm task.json
            else
                terraform output therapist-signup-service-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/therapist-signup/service-task-definition/task.json
                rm task.json
            fi
        done
        break
        ;;
        "patient-self-report")
        for SERVICE_NAME in patient-self-report-resque-worker patient-self-report-scheduler-worker \
            patient-self-report-service
        do
            echo "Service Name: $SERVICE_NAME"
            if [ $(echo $SERVICE_NAME | grep resque) ]
            then
                terraform output patient-self-report-resque-worker-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/patient-self-report/resque-task-definition/task.json
                rm task.json
            elif [ $(echo $SERVICE_NAME | grep scheduler) ]
            then
                terraform output patient-self-report-scheduler-worker-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/patient-self-report/scheduler-task-definition/task.json
                rm task.json
            else
                terraform output patient-self-report-service-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/patient-self-report/service-task-definition/task.json
                rm task.json
            fi
        done
        break
        ;;
        "forms")
        echo "Service Name: forms"
        terraform output forms-service-task-definition-json > task.json
        aws s3 cp task.json s3://luna-staging-custom/forms/service-task-definition/task.json
        rm task.json
        break
        ;;
        "marketplace")
        for SERVICE_NAME in marketplace-rq-echo-worker marketplace-rq-scheduler-worker \
            marketplace-service
        do
            echo "Service Name: $SERVICE_NAME"
            if [ $(echo $SERVICE_NAME | grep echo) ]
            then
                terraform output marketplace-rq-echo-worker-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/marketplace/echo-task-definition/task.json
                rm task.json
            elif [ $(echo $SERVICE_NAME | grep scheduler) ]
            then
                terraform output marketplace-rq-scheduler-worker-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/marketplace/scheduler-task-definition/task.json
                rm task.json
            else
                terraform output marketplace-service-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/marketplace/service-task-definition/task.json
                rm task.json
            fi
        done
        break
        ;;
        "edge")
        for SERVICE_NAME in edge-resque-worker edge-scheduler-worker edge-service
        do
            echo "Service Name: $SERVICE_NAME"
            if [ $(echo $SERVICE_NAME | grep resque) ]
            then
                terraform output edge-resque-worker-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/edge/resque-task-definition/task.json
                rm task.json
            elif [ $(echo $SERVICE_NAME | grep scheduler) ]
            then
                terraform output edge-resque-scheduler-worker-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/edge/scheduler-task-definition/task.json
                rm task.json
            else
                terraform output edge-service-task-definition-json > task.json
                aws s3 cp task.json s3://luna-staging-custom/edge/service-task-definition/task.json
                rm task.json
            fi
        done
        break
        ;;
        *)echo "invalid option $REPLY";;
    esac
done
