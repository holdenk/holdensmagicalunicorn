from django.conf.urls import *

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
from django.conf import settings
admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'unicorn.views.home', name='home'),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
     url(r'^admin/', include(admin.site.urls)),
     url(r'^$', 'verify.views.index'),
     url(r'^review', 'verify.views.review'),
     url(r'^export', 'verify.views.export'),
     url(r'accounts/', include('social_auth.urls')),
)


if settings.DEBUG:
    urlpatterns += patterns('',
        (r'^staticz/(?P<path>.*)$', 'django.views.static.serve', {'document_root': settings.STATIC_ROOT, 'show_indexes': True}),
    )
