# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
"""Client and server classes corresponding to protobuf-defined services."""
import grpc
import warnings

import timezone_pb2 as timezone__pb2

GRPC_GENERATED_VERSION = '1.73.1'
GRPC_VERSION = grpc.__version__
_version_not_supported = False

try:
    from grpc._utilities import first_version_is_lower
    _version_not_supported = first_version_is_lower(GRPC_VERSION, GRPC_GENERATED_VERSION)
except ImportError:
    _version_not_supported = True

if _version_not_supported:
    raise RuntimeError(
        f'The grpc package installed is at version {GRPC_VERSION},'
        + f' but the generated code in timezone_pb2_grpc.py depends on'
        + f' grpcio>={GRPC_GENERATED_VERSION}.'
        + f' Please upgrade your grpc module to grpcio>={GRPC_GENERATED_VERSION}'
        + f' or downgrade your generated code using grpcio-tools<={GRPC_VERSION}.'
    )


class TimezoneConverterStub(object):
    """Missing associated documentation comment in .proto file."""

    def __init__(self, channel):
        """Constructor.

        Args:
            channel: A grpc.Channel.
        """
        self.ConvertTime = channel.unary_unary(
                '/timezone.TimezoneConverter/ConvertTime',
                request_serializer=timezone__pb2.TimeConversionRequest.SerializeToString,
                response_deserializer=timezone__pb2.TimeConversionResponse.FromString,
                _registered_method=True)


class TimezoneConverterServicer(object):
    """Missing associated documentation comment in .proto file."""

    def ConvertTime(self, request, context):
        """Converts the time into a target timezone
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')


def add_TimezoneConverterServicer_to_server(servicer, server):
    rpc_method_handlers = {
            'ConvertTime': grpc.unary_unary_rpc_method_handler(
                    servicer.ConvertTime,
                    request_deserializer=timezone__pb2.TimeConversionRequest.FromString,
                    response_serializer=timezone__pb2.TimeConversionResponse.SerializeToString,
            ),
    }
    generic_handler = grpc.method_handlers_generic_handler(
            'timezone.TimezoneConverter', rpc_method_handlers)
    server.add_generic_rpc_handlers((generic_handler,))
    server.add_registered_method_handlers('timezone.TimezoneConverter', rpc_method_handlers)


 # This class is part of an EXPERIMENTAL API.
class TimezoneConverter(object):
    """Missing associated documentation comment in .proto file."""

    @staticmethod
    def ConvertTime(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(
            request,
            target,
            '/timezone.TimezoneConverter/ConvertTime',
            timezone__pb2.TimeConversionRequest.SerializeToString,
            timezone__pb2.TimeConversionResponse.FromString,
            options,
            channel_credentials,
            insecure,
            call_credentials,
            compression,
            wait_for_ready,
            timeout,
            metadata,
            _registered_method=True)
