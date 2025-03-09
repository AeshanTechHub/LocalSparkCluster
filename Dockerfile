# The term python:3.11-bullseye refers to a specific Docker image for Python. Here's what it means:
# 
# python:3.11: This specifies the Python version, in this case, Python 3.11.
#
# bullseye: This indicates the base operating system used in the Docker image, which is Debian 11 (codenamed "Bullseye"). 
# It's a stable and widely-used Linux distribution.
FROM python:3.11-bullseye as spark-base

# Define the version of Spark to install
ARG SPARK_VERSION=3.5.5

# Install and update dependencies in Debian and clean up the cache and remove unnecessary files
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      sudo \
      curl \
      vim \
      unzip \
      rsync \
      openjdk-11-jdk \
      build-essential \
      software-properties-common \
      ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*do

# Set the environment variables for Spark and Hadoop
ENV SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
ENV HADOOP_HOME=${HADOOP_HOME:-"/opt/hadoop"}

# Make directories for Spark and Hadoop then set the working directory to Spark
RUN mkdir -p ${HADOOP_HOME} && mkdir -p ${SPARK_HOME}
WORKDIR ${SPARK_HOME}

# Set the environment variables for Spark and python
ENV PATH="/opt/spark/sbin:/opt/spark/bin:${PATH}"
ENV SPARK_HOME="/opt/spark"
ENV SPARK_MASTER="spark://spark-master:7077"
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

# Stepup the Spark in Directory
# Download and extract the Spark binary to the /opt/spark directory
RUN curl https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz -o spark-${SPARK_VERSION}-bin-hadoop3.tgz \
 && tar xvzf spark-${SPARK_VERSION}-bin-hadoop3.tgz --directory ${SPARK_HOME} --strip-components 1 \
 && rm -rf spark-${SPARK_VERSION}-bin-hadoop3.tgz

# Install the Python dependencies
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Copy the default Spark configuration files for Spark Installation
COPY conf/spark-defaults.conf "$SPARK_HOME/conf"

# Setting up the Spark Environment and ensure the permissions (1st path) are set correctly to run the Spark in the Docker Container
RUN chmod u+x /opt/spark/sbin/* && \
    chmod u+x /opt/spark/bin/*

# Set the Python path to include the Spark Python directory
ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH

# Start the service based on the workload: Spark Master , Worker , History
COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]
