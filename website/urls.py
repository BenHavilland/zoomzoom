from django.conf.urls import patterns, include, url
from django.conf import settings
# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('django.views.generic.simple',
    # Examples:
    # url(r'^$', 'website.views.home', name='home'),
    # url(r'^website/', include('website.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
    url(r'^$', 'direct_to_template', {'template': 'index.html'}),
    url(r'^zoomzoom/(?P<path>.*)$', 'redirect_to', {'url': settings.ZOOMZOOM_PATH}),
)

if settings.DEBUG:
    urlpatterns += patterns('',
        url(r'^static/(?P<path>.*)$', 'django.views.static.serve', {
            'document_root': settings.MEDIA_ROOT,
        }),
   )

if not settings.DEBUG:
   urlpatterns += patterns('',
       url(r'^static/(?P<path>.*)$', 'django.views.static.serve', {
           'document_root': settings.STATIC_ROOT}),
   )
