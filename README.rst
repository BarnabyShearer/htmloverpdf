===========
htmloverpdf
===========
.. image:: https://readthedocs.org/projects/htmloverpdf/badge/?version=latest
    :target: https://htmloverpdf.readthedocs.io/en/latest/
.. image:: https://img.shields.io/pypi/v/htmloverpdf?color=success
    :target: https://pypi.org/project/htmloverpdf
.. image:: https://img.shields.io/docker/v/barnabyshearer/htmloverpdf/latest?color=success&label=docker
    :target: https://hub.docker.com/repository/docker/barnabyshearer/htmloverpdf

Render a HTML overlay over existing PDF files.

Install
-------

.. code-block:: bash

    sudo apt install libgirepository1.0-dev gir1.2-poppler-0.18 gir1.2-pango-1.0
    python3 -m pip install htmloverpdf

A wrapper for https://weasyprint.org/ which allows compositing with existing PDF files.
            
It parses the HTML looking for <img> tags with src urls ending ".pdf". Each one begins a new page and copies all source pages overlaying the weasyprint output.
The magic value "blank.pdf" outputs sections HTML without overlaying.

Usage
-----

::

    htmloverpdf < test.html > test.pdf


