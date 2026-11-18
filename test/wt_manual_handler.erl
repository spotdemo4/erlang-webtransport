%% @doc Test handler for `flow_control => manual': it tells `owner' its
%% session and how many bytes arrive on each stream, and returns at once.
%% The owner returns the credit with webtransport:consume/3.
-module(wt_manual_handler).
-behaviour(webtransport_handler).

-export([init/3, handle_stream/4, handle_datagram/2, handle_stream_closed/3,
         terminate/2]).

init(Session, _Req, #{owner := Owner}) ->
    Owner ! {manual_session, Session},
    {ok, Owner}.

handle_stream(StreamId, _Type, Data, Owner) ->
    Owner ! {manual_data, StreamId, byte_size(Data)},
    {ok, Owner}.

handle_datagram(_Data, Owner) ->
    {ok, Owner}.

handle_stream_closed(_StreamId, _Reason, Owner) ->
    {ok, Owner}.

terminate(_Reason, _Owner) ->
    ok.
