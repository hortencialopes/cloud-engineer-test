from concurrent import futures
import grpc 
from datetime import datetime
import pytz

import timezone_pb2
import timezone_pb2_grpc

class TimezoneConverterServicer(timezone_pb2_grpc.TimezoneConverterServicer):
    """
        Implements the timezoneconverter service
    """

    def ConvertTime (self, request, context):
        """
            Receives the time (current time of the client), a source timezone and a target timezon returning the converted time
        """
        print(f"Received request to convert {request.time_str} from {request.source_timezone} to {request.target_timezone}")

        try:
            dt_format = "%Y-%m-%d %H:%M:%S"

            source_tz = pytz.timezone(request.source_timezone)
            target_tz = pytz.timezone(request.target_timezone)

            #convert the entry hour - lets say 18:35 - to the adequate format
            naive_dt = datetime.strptime(request.time_str, dt_format)

            source_dt = source_tz.localize(naive_dt) #map the entry to the source_dt of the server 

            target_dt = source_dt.astimezone(target_tz) #convert the target timezone to the target time (of the target timezone lol)

            converted_time_str = target_dt.strftime(dt_format)

            return timezone_pb2.TimeConversionResponse(
                converted_time = converted_time_str,
                target_timezone=request.target_timezone
            )
        
        except pytz.UnknownTimeZoneError as e:
            print(f"Error: Unknown timezone - {e}")
            context.set_code(grpc.StatusCode.INVALID_ARGUMENT)
            context.set_details(f"Invalid timezone provided: {e}")
            return timezone_pb2.TimeConversionResponse()
        except ValueError as e:
            print(f"Error: Invalid time format - {e}")
            context.set_code(grpc.StatusCode.INVALID_ARGUMENT)
            context.set_details(f"Invalid time format. Use 'YYYY-MM-DD HH:MM:SS'.")
            return timezone_pb2.TimeConversionResponse()


def serve():
    """Starts the gRPC server."""
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    timezone_pb2_grpc.add_TimezoneConverterServicer_to_server(TimezoneConverterServicer(), server)
    server.add_insecure_port('[::]:50051')
    print("Server starting on port 50051...")
    server.start()
    server.wait_for_termination()

if __name__ == '__main__':
    serve()