# LocalSparkCluster
This repository contains steps to set up a Spark cluster locally, enabling easy prototyping and development without requiring a distributed environment.

## Repository Structure

- `start-cluster.sh`: Script to start the Spark cluster.
- `spark_apps/`: Directory to place your Spark application scripts.
- `input_data/`: Directory to place your input data files.
- `Makefile`: Contains commands to manage the Spark cluster and submit applications.

## Steps to Use This Code

1. **Install Dependencies**
    Ensure you have Java and Spark installed on your machine. You can follow the official installation guides for [Java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) and [Spark](https://spark.apache.org/downloads.html).

2. **Start the Spark Cluster**
    ```sh
    ./start-cluster.sh
    ```

3. **Submit a Spark Job**
    ```sh
    ./bin/spark-submit --class org.apache.spark.examples.SparkPi --master local[4] /path/to/examples.jar 100
    ```

## Example Usage

Here is an example of how to run a simple Spark job:

1. **Create a Python Script**
    Create a file named `example.py` with the following content:
    ```python
    from pyspark.sql import SparkSession

    spark = SparkSession.builder.appName("Example").getOrCreate()
    data = [("Alice", 1), ("Bob", 2), ("Cathy", 3)]
    df = spark.createDataFrame(data, ["Name", "Value"])
    df.show()
    spark.stop()
    ```

2. **Run the Script**
    ```sh
    ./bin/spark-submit example.py
    ```

This will start a local Spark session, create a DataFrame, and display its content.

## Makefile Usage

### Running the Cluster

To start the Spark cluster using the Makefile, run:
```sh
make run
```
This command will execute the necessary steps to start the cluster.

### Running a Scaled Cluster

To start a scaled Spark cluster, use:
```sh
make run-scaled
```
This command will configure and start a Spark cluster with multiple worker nodes.

### Submitting a Spark Application

To submit a Spark application, add your Python script to the `spark_apps` folder and run:
```sh
make submit app=example.py
```
Replace `example.py` with the name of your script.

### Input Data

Place your input data files in the `input_data` folder. If you want to store data in Hadoop, use the path `/opt/hadoop/<path>`.

## Example Makefile Commands

1. **Start the Cluster**
    ```sh
    make run
    ```

2. **Start a Scaled Cluster**
    ```sh
    make run-scaled
    ```

3. **Submit a Spark Application**
    ```sh
    make submit app=example.py
    ```

4. **Place Data Files**
    Add your data files to the `input_data` directory for processing.

By following these steps, you can easily manage your local Spark cluster and run Spark applications.
