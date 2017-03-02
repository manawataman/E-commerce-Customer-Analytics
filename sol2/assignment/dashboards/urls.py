from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$',views.index,name='index'),
    url(r'^1$',views.subdetails1,name='subdetails1'),
    url(r'^2$',views.subdetails2,name='subdetails2'),
    url(r'^3$',views.subdetails3,name='subdetails3'),
]