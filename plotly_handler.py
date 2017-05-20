""" Plotly handler class"""
import plotly.plotly as py
import plotly.tools as tls
from plotly.graph_objs import *
import time


class PlotlyHandler:
    """ Plotly wrapper to setup session and send data over to Plotly API """

    def __init__(self):
        """ Initializes Plotly Session
            Setting up Plotly streams/traces (adapted from Plotly example) """

        self._stream_ids = tls.get_credentials_file()['stream_ids']

        # Plotly first scatter object
        self._trace1 = Scatter(
            x=[],
            y=[],
            mode='lines+markers',
            name='Pendulum arms',
            marker=Marker(size=12),
            stream=Stream(token=self._stream_ids[0])
        )

        # Plotly second scatter object
        self._trace2 = Scatter(
            x=[],
            y=[],
            mode='lines',
            name='Trace of second pendulum',
            line=Line(color='rgba(255,0,0,0.30)'),
            stream=Stream(
                token=self._stream_ids[1],
                maxpoints=100
            )
        )

        # Plotly data object
        self._data = Data([self._trace1, self._trace2])
        # Axes options
        axis_style = dict(
            showgrid=True,
            showline=True,
            zeroline=True
        )

        # Plotly layout and labels
        self._layout = Layout(
            title='Double Pendulum: chaotic motion',
            xaxis=XAxis(
                axis_style,
                range=[-2, 2]
            ),
            yaxis=YAxis(
                axis_style,
                range=[-2, 0.5]
            ),
            showlegend=True
        )

        # Plotly figure object
        self._fig = Figure(data=self._data, layout=self._layout)
        # Send fig to Plotly
        self._url = py.plot(self._fig, filename='streaming_double-pendulum')

        # Streams (of data)
        self._s1 = py.Stream(self._stream_ids[0])
        self._s2 = py.Stream(self._stream_ids[1])
        self._s1.open()
        self._s2.open()

    def send_plotly(self, data):
        """ Feed data to Plotly streams (closes streams when done) """

        for x1, y1, x2, y2 in data:
            self._s1.write(dict(x=[0, x1, x2], y=[0, y1, y2]))
            self._s2.write(dict(x=x2, y=y2))
            time.sleep(0.08)

        # Closing streams
        self._s1.close()
        self._s2.close()
