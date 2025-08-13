# Other ProGuard rules for your project

# Rules from missing_rules.txt
#-dontwarn com.google.api.client.http.GenericUrl
#-dontwarn com.google.api.client.http.HttpHeaders
#-dontwarn com.google.api.client.http.HttpRequest
#-dontwarn com.google.api.client.http.HttpRequestFactory
#-dontwarn com.google.api.client.http.HttpResponse
#-dontwarn com.google.api.client.http.HttpTransport
#-dontwarn com.google.api.client.http.javanet.NetHttpTransport$Builder
#-dontwarn com.google.api.client.http.javanet.NetHttpTransport
#-dontwarn javax.xml.stream.Location
#-dontwarn javax.xml.stream.XMLInputFactory
#-dontwarn javax.xml.stream.XMLStreamException
#-dontwarn javax.xml.stream.XMLStreamReader
#-dontwarn org.apache.commons.cli.CommandLine
#-dontwarn org.apache.commons.cli.CommandLineParser
#-dontwarn org.apache.commons.cli.GnuParser
#-dontwarn org.apache.commons.cli.HelpFormatter
#-dontwarn org.apache.commons.cli.Option
#-dontwarn org.apache.commons.cli.Options
#-dontwarn org.apache.commons.cli.ParseException
#-dontwarn org.aspectj.lang.JoinPoint
#-dontwarn org.aspectj.lang.annotation.Aspect
#-dontwarn org.aspectj.lang.annotation.Before
#-dontwarn org.joda.time.Instant
#-dontwarn org.xbill.DNS.Lookup
#-dontwarn org.xbill.DNS.Name
#-dontwarn org.xbill.DNS.Record
#-dontwarn org.xbill.DNS.SRVRecord
#-dontwarn org.xbill.DNS.TextParseException

#-printmapping mapping.txt
#-printseeds seeds.txt
#-printusage usage.txt

-dontwarn com.google.errorprone.annotations.CanIgnoreReturnValue
-dontwarn com.google.errorprone.annotations.CheckReturnValue
-dontwarn com.google.errorprone.annotations.Immutable
-dontwarn com.google.errorprone.annotations.InlineMe
-dontwarn com.google.errorprone.annotations.RestrictedApi
-dontwarn javax.annotation.Nonnull
-dontwarn javax.annotation.Nullable
-dontwarn javax.annotation.concurrent.GuardedBy
-dontwarn javax.annotation.concurrent.Immutable
-dontwarn javax.annotation.concurrent.NotThreadSafe
-dontwarn javax.annotation.concurrent.ThreadSafe
-dontwarn javax.annotation.meta.TypeQualifierDefault
-dontwarn org.bouncycastle.jsse.BCSSLParameters
-dontwarn org.bouncycastle.jsse.BCSSLSocket
-dontwarn org.bouncycastle.jsse.provider.BouncyCastleJsseProvider
-dontwarn org.conscrypt.Conscrypt$Version
-dontwarn org.conscrypt.Conscrypt
-dontwarn org.conscrypt.ConscryptHostnameVerifier
-dontwarn org.openjsse.javax.net.ssl.SSLParameters
-dontwarn org.openjsse.javax.net.ssl.SSLSocket
-dontwarn org.openjsse.net.ssl.OpenJSSE

-dontwarn com.google.api.client.http.GenericUrl
-dontwarn com.google.api.client.http.HttpHeaders
-dontwarn com.google.api.client.http.HttpRequest
-dontwarn com.google.api.client.http.HttpRequestFactory
-dontwarn com.google.api.client.http.HttpResponse
-dontwarn com.google.api.client.http.HttpTransport
-dontwarn com.google.api.client.http.javanet.NetHttpTransport$Builder
-dontwarn com.google.api.client.http.javanet.NetHttpTransport
-dontwarn javax.xml.stream.Location
-dontwarn javax.xml.stream.XMLInputFactory
-dontwarn javax.xml.stream.XMLStreamException
-dontwarn javax.xml.stream.XMLStreamReader
-dontwarn org.apache.commons.cli.CommandLine
-dontwarn org.apache.commons.cli.CommandLineParser
-dontwarn org.apache.commons.cli.GnuParser
-dontwarn org.apache.commons.cli.HelpFormatter
-dontwarn org.apache.commons.cli.Option
-dontwarn org.apache.commons.cli.Options
-dontwarn org.apache.commons.cli.ParseException
-dontwarn org.aspectj.lang.JoinPoint
-dontwarn org.aspectj.lang.annotation.Aspect
-dontwarn org.aspectj.lang.annotation.Before
-dontwarn org.joda.time.Instant
-dontwarn org.xbill.DNS.Lookup
-dontwarn org.xbill.DNS.Name
-dontwarn org.xbill.DNS.Record
-dontwarn org.xbill.DNS.SRVRecord
-dontwarn org.xbill.DNS.TextParseException

-dontwarn com.google.devtools.build.android.desugar.runtime.ThrowableExtension

-dontwarn a.**
-keep class a.** { *; }

-keep class com.mirrorfly.mirrorfly_plugin.FlyChatPlugin { *; }
