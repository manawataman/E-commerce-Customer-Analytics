from django.shortcuts import render

# Create your views here.
from django.http import HttpResponse
import requests
import json
from elasticsearch import Elasticsearch
from datetime import datetime
from elasticsearch_dsl import DocType, String, Date, Integer
from elasticsearch_dsl.connections import connections
from elasticsearch_dsl import Search, Q

from django.db.models import Count
from django.conf import settings
from django.shortcuts import render
from django.views.generic.base import TemplateView

client = connections.create_connection(hosts=['http://localhost:9200'])
s = Search(using=client)
body = {
    "size": 0,
    "query": {
        "bool": {
            "must": [
                {
                    "query_string": {
                        "query": "*",
                        "analyze_wildcard": True
                    }
                }
            ],
            "must_not": []
        }
    },
    "aggs": {
        "products": {
            "nested": {
                "path": "products.traits"
            },
            "aggs": {
                "top_brands": {
                    "filter": {
                        "term": {
                            "products.traits.key.raw": "Product Brand"
                        }
                    },
                    "aggs": {
                        "value": {
                            "terms": {
                                "field": "products.traits.value.raw",
                                "size": 3,
                                "order": {
                                    "_count": "desc"
                                }
                            },
                            "aggs": {
                                "user": {
                                    "reverse_nested": {},
                                    "aggs": {
                                        "products": {
                                            "nested": {
                                                "path": "products.traits"
                                            },
                                            "aggs": {
                                                "top_brands": {
                                                    "filter": {
                                                        "term": {
                                                            "products.traits.key.raw": "Product Name"
                                                        }
                                                    },
                                                    "aggs": {
                                                        "value": {
                                                            "terms": {
                                                                "field": "products.traits.value.raw",
                                                                "size": 3,
                                                                "order": {
                                                                    "_count": "desc"
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

s = Search.from_dict(body)
s = s.index("clabs_two")
body = s.to_dict()
t = s.execute()



def index(request):
    list4 =[]
    list3 = ['brand','count']
    list4.append(list3)
    list3=[]
    for item in t.aggregations.products.top_brands.value.buckets:
        list3.append(item.key)
        list3.append(item.doc_count)
        list4.append(list3)
        for tt in item.user.products.top_brands.value.buckets:
            list3 = []
    return render(request,'dashboards/index.html',{'array': json.dumps(list4)})


def subdetails1(request):
    list3 = []
    list6 = []
    for item in t.aggregations.products.top_brands.value.buckets:
        list3.append(item.key)
        list5 = []
        for tt in item.user.products.top_brands.value.buckets:
            list5.append(tt.key)
            list5.append(tt.doc_count)
        list3.append(list5)
        list6.append(list3)
        list3 = []

    for item in list6:
        for ty in item:
            print(ty)
        print("\n")
    return render(request, 'dashboards/1.html', {'array': json.dumps(list6)})

def subdetails2(request):
    list3 = []
    list6 = []
    for item in t.aggregations.products.top_brands.value.buckets:
        list3.append(item.key)
        list5 = []
        for tt in item.user.products.top_brands.value.buckets:
            list5.append(tt.key)
            list5.append(tt.doc_count)
        list3.append(list5)
        list6.append(list3)
        list3 = []

    for item in list6:
        for ty in item:
            print(ty)
        print("\n")
    return render(request, 'dashboards/2.html', {'array': json.dumps(list6)})

def subdetails3(request):
    list3 = []
    list6 = []
    for item in t.aggregations.products.top_brands.value.buckets:
        list3.append(item.key)
        list5 = []
        for tt in item.user.products.top_brands.value.buckets:
            list5.append(tt.key)
            list5.append(tt.doc_count)
        list3.append(list5)
        list6.append(list3)
        list3 = []

    for item in list6:
        for ty in item:
            print(ty)
        print("\n")
    return render(request, 'dashboards/3.html', {'array': json.dumps(list6)})
