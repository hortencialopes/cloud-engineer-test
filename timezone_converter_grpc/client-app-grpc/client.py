import grpc 
import os
import timezone_pb2
import timezone_pb2_grpc

def run():
    """
    Sends a request to the gRPC server
    stub is a client obj
    """
    # Ill have to add the server address as env varible (when it's up lol)
    server_address = os.getenv('GRPC_SERVER_ADDRESS')

    if not server_address:
        print("Error: GRPC_SERVER_ADDRESS environment variable not set.")
        print("Usage: export GRPC_SERVER_ADDRESS=<your-alb-address>:443")
        return
    
    print(f"Attempting to connect to server at {server_address}...")


    try:
        with grpc.secure_channel(server_address, grpc.ssl_channel_credentials()) as channel:

            stub = timezone_pb2_grpc.TimezoneConverterStub(channel)
            default_time = "2024-07-12 10:00:00"
            default_source_tz = "America/Sao_Paulo"
            default_target_tz = "America/Bogota"

            request = timezone_pb2.TimeConversionRequest (
                time_str= input('Enter time in format "2025-07-12 10:00:00": ') or default_time,
                source_timezone = input('Enter source timezone. Example: America/Sao_Paulo: ') or default_source_tz,
                target_timezone = input('Enter target timezone. Example: America/Bogota: ') or default_target_tz,
            )

            print(f"------- Sending request to convert {request.time_str} from {request.source_timezone} to {request.target_timezone} ---")


            try:
                response = stub.ConvertTime(request, timeout=15)
                print(f"Success! Converted time: {response.converted_time} {response.target_timezone}")
            except grpc.RpcError as e:
                print(f"An error occurred: {e.code()} - {e.details()}")
    except Exception as e:
        print(f"Failed to create a secure channel: {e}")

if __name__ == '__main__':
    run()