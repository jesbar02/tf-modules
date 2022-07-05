require 'json'
require 'aws-sdk-ecs'
require 'aws-sdk-autoscaling'
ECS = Aws::ECS::Client.new
ASG = Aws::AutoScaling::Client.new

CLUSTER_NAME = ENV['CLUSTER_NAME']

def get_container_instances(container_instance_arns)
    ECS.describe_container_instances({
      cluster: CLUSTER_NAME,
      container_instances: container_instance_arns
    })['container_instances']
end

def lambda_handler(event:, context:)
    # TODO implement
    container_instance_arns = ECS.list_container_instances({cluster: CLUSTER_NAME})['container_instance_arns']
    container_instances = get_container_instances(container_instance_arns)
    container_instance_arn = ""
    container_instances.each do |instance|
        if instance['ec2_instance_id'] == event['detail']['EC2InstanceId']
            container_instance_arn = instance['container_instance_arn']
            ECS.update_container_instances_state({
                cluster: CLUSTER_NAME,
                container_instances: [container_instance_arn],
                status: "DRAINING"
            })
            break
        end
    end
    while true
        if get_container_instances([container_instance_arn])[0]['running_tasks_count'] == 0
            ASG.complete_lifecycle_action({
              auto_scaling_group_name: event['detail']['AutoScalingGroupName'],
              lifecycle_action_result: "CONTINUE",
              lifecycle_action_token: event['detail']['LifecycleActionToken'],
              lifecycle_hook_name: event['detail']['LifecycleHookName']
            })
            break
        end
        sleep 2
    end
    { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end
