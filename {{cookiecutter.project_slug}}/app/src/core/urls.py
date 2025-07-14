"""
URL configuration for core project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include
from core.metrics import metrics_view
{% if cookiecutter.use_business_metrics == "y" %}
from core.business_metrics import metrics_manager
{% endif %}

urlpatterns = [
    path("admin/", admin.site.urls),
{% if cookiecutter.use_prometheus == "y" %}
    path("metrics", metrics_view, name="prometheus-django-metrics"),
{% endif %}

{% if cookiecutter.use_business_metrics == "y" %}
path("business-metrics", metrics_manager.view, name="prometheus-business-metrics"),
{% endif %}
{% if cookiecutter.use_health_check == "y" %}
path("healthcheck/", include("health_check.urls")),
{% endif %}
]

if settings.DEBUG:
    # static files (images, css, javascript, etc.)
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)