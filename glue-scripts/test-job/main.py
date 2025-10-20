import sys
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.context import SparkContext

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glue = GlueContext(sc)
job = Job(glue)
job.init(args['JOB_NAME'], args)

print("✅ Hello from Glue test job!")

job.commit()
