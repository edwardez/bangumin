# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy

class User(scrapy.Item):
    name = scrapy.Field()
    uid = scrapy.Field()
    date = scrapy.Field()
    prohibited = scrapy.Field()


class Record(scrapy.Item):
    ## First five items are required.
    name = scrapy.Field()
    typ = scrapy.Field()
    iid = scrapy.Field() #name and id together forms primary key.
    state = scrapy.Field()
    date = scrapy.Field()
    ## Following three are optional.
    rate = scrapy.Field()
    tags = scrapy.Field()

class Index(scrapy.Item):
    indexid = scrapy.Field()
    creator = scrapy.Field()
    favourite = scrapy.Field()
    date = scrapy.Field()
    items = scrapy.Field()

class Friend(scrapy.Item):
    """This item keeps a directed relationship that user is following his/her friend."""
    user = scrapy.Field()
    friend = scrapy.Field()
    # No date information

class SubjectInfo(scrapy.Item):
    """This is not the final subject item. It is intended to collect infobox terms and types of relationships"""
    subjectid = scrapy.Field()
    subjecttype = scrapy.Field()
    infobox = scrapy.Field()
    relations = scrapy.Field()
