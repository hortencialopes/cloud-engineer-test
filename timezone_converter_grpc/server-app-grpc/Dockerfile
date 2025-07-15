FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the generated proto files to the container
COPY timezone_pb2.py .
COPY timezone_pb2_grpc.py .
# application code
COPY server/ ./server/

# port the gRPC server will run on
EXPOSE 50051

# thsi is how the app will run
CMD ["python", "-m", "server.server"]