from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
import sys

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glue = GlueContext(sc)
job = Job(glue)
job.init(args['JOB_NAME'], args)

print("✅ Running Sales Report Job!")

job.commit()
