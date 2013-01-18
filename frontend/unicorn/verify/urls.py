from django.conf.urls import patterns, url

from verify import views

urlpatterns = patterns('',
    url(r'^$', views.index, name='index')
)
