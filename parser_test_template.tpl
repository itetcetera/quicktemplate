This is a test template file.
All the lines outside func and code are just comments.

Optional imports must be at the top of template
{% import (
	"fmt"
	"strconv"
)
%}

Arbitrary go code may be inserted here. For instance, type definition:
{% code
type FooArgs struct {
	S string
	N int	
}
%}

Now define an exported function template
{% func Foo(a []FooArgs) %}
	<h1>Hello, I'm Foo!</h1>
	<div>
		My args are:
		{% if len(a) == 0 %}
			no args!
		{% elseif len(a) == 1 %}
			a single arg: {%= printArgs(0, &a[0]) %}
		{% else %}
			<ul>
			{% for i, aa := range a %}
				{% if i >= 42 %}
					There are other args, but only the first 42 of them are shown
					{% break %}
					All the stuff after break {%s "is" %} ignored
				{% endif %}
				{%= printArgs(i, &aa) %}
				Arbitrary Go code may be inserted here: {% code	str := strconv.Itoa(i+42) %}
				str = {%s fmt.Sprintf("this html will be escaped <b>%s</b>", str) %}
			{% endfor %}
			</ul>
		{% endif %}
	</div>
	{% plain %}
		Arbitrary tags are treated as plaintext inside plain.
		For instance, {% foo %} {% bar %} {% for %}
		{% func %} {% code %} {% return %} {% break %} {% comment %}
		and even {% unclosed tag
	{% endplain %}
	{% collapsespace %}
		Leading and trailing space between template tags is collapsed
		on each line inside collapsespace unless {%space%} or {%newline%} is used
	{% endcollapsespace %}
{% endfunc %}

{%plain%}
Now define private printArgs, which is used in Foo via {%= %} tag
{%endplain%}
{% func printArgs(i int, a *FooArgs) %}
	{% if i == 0 %}
		Hide args for i = 0
		{% return %}
		All the stuff after return is ignored:
		{% if 123 %}this{% endif %}
		{% for %}And this: {% break %} {% return %}{% endfor %}
	{% endif %}
	<li>
		a[{%d i %}] = {S: {%q a.S %}, N: {%d a.N %}}<br>
	</li>
{% endfunc %}


// Now create base template struct.
{% code type Base struct {} %}

{% func (b *Base) Run() %}
	<html>
		<head>{%= b.Head() %}</head>
		<body>{%= b.Body() %}</body>
	</html>
{% endfunc %}

{% func (b *Base) Head() %}<title>Base title. Override it!</title>{% endfunc %}
{% func (b *Base) Body() %}Base body. Override it!{% endfunc Body %}

// Now create derived template struct.
{% code
type Homepage struct {
	Base
}
%}

{% func (h *Homepage) Head() %}<title>Homepage</title>{% endfunc %}
{% func (h *Homepage) Body() %}
	Homepage body.
	And this is base body: {%= h.Base.Body() %}
{% endfunc %}

unused code may be commented:
{% comment %}
{% func UnusedFunc(n int) %}
	foobar
{% endfunc %}
{% endcomment %}
