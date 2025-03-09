import pyspark.sql.functions as F
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName(
    "Test Spark."
).getOrCreate()

df = spark.read.csv("/opt/spark/data/test_data.csv", header=True)


df.show()

df.write.csv("/opt/hadoop/output/test_data_out.csv", header=True)