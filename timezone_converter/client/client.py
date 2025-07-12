import grpc 
import timezone_pb2, timezone_pb2_grpc

def run():
    """
    Sends a request to the gRPC server
    stub is a client obj
    """

    with grpc.insecure_channel('localhost:50051') as channel:

        stub = timezone_pb2_grpc.TimezoneConverterStub(channel)

        request = timezone_pb2.TimeConversionRequest (
            time_str = "2025-07-12 00:01:00"
            source_timezone = "America/Sao_Paulo"
            target_timezone="America/Bogota"
        )

        print(f"------- Sending request to convert {request.time_str} from {request.source_timezone} to {request.target_timezone} ---")


        try:
            response = stub.ConvertTime(request)
            print(f"Success! Converted time: {response.converted_time} {response.target_timezone}")
        except grpc.RpcError as e:
            # Handle potential errors
            print(f"An error occurred: {e.code()} - {e.details()}")

if __name__ == '__main__':
    run()