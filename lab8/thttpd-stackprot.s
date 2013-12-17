	.file	"thttpd.c"
	.local	argv0
	.comm	argv0,4,4
	.local	debug
	.comm	debug,4,4
	.local	port
	.comm	port,2,2
	.local	dir
	.comm	dir,4,4
	.local	data_dir
	.comm	data_dir,4,4
	.local	do_chroot
	.comm	do_chroot,4,4
	.local	no_log
	.comm	no_log,4,4
	.local	no_symlink_check
	.comm	no_symlink_check,4,4
	.local	do_vhost
	.comm	do_vhost,4,4
	.local	do_global_passwd
	.comm	do_global_passwd,4,4
	.local	cgi_pattern
	.comm	cgi_pattern,4,4
	.local	cgi_limit
	.comm	cgi_limit,4,4
	.local	url_pattern
	.comm	url_pattern,4,4
	.local	no_empty_referers
	.comm	no_empty_referers,4,4
	.local	local_pattern
	.comm	local_pattern,4,4
	.local	logfile
	.comm	logfile,4,4
	.local	throttlefile
	.comm	throttlefile,4,4
	.local	hostname
	.comm	hostname,4,4
	.local	pidfile
	.comm	pidfile,4,4
	.local	user
	.comm	user,4,4
	.local	charset
	.comm	charset,4,4
	.local	p3p
	.comm	p3p,4,4
	.local	max_age
	.comm	max_age,4,4
	.local	throttles
	.comm	throttles,4,4
	.local	numthrottles
	.comm	numthrottles,4,4
	.local	maxthrottles
	.comm	maxthrottles,4,4
	.local	connects
	.comm	connects,4,4
	.local	num_connects
	.comm	num_connects,4,4
	.local	max_connects
	.comm	max_connects,4,4
	.local	first_free_connect
	.comm	first_free_connect,4,4
	.local	httpd_conn_count
	.comm	httpd_conn_count,4,4
	.local	hs
	.comm	hs,4,4
	.globl	terminate
	.bss
	.align 4
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	4
	.comm	start_time,4,4
	.comm	stats_time,4,4
	.comm	stats_connections,4,4
	.comm	stats_bytes,4,4
	.comm	stats_simultaneous,4,4
	.local	got_hup
	.comm	got_hup,4,4
	.local	got_usr1
	.comm	got_usr1,4,4
	.local	watchdog_flag
	.comm	watchdog_flag,4,4
	.section	.rodata
.LC0:
	.string	"exiting due to signal %d"
	.text
	.type	handle_term, @function
handle_term:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	call	shut_down
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC0, 4(%esp)
	movl	$5, (%esp)
	call	syslog
	call	closelog
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE0:
	.size	handle_term, .-handle_term
	.section	.rodata
.LC1:
	.string	"child wait - %m"
	.text
	.type	handle_chld, @function
handle_chld:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, -16(%ebp)
.L10:
	movl	$1, 8(%esp)
	leal	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$-1, (%esp)
	call	waitpid
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L3
	jmp	.L4
.L3:
	cmpl	$0, -12(%ebp)
	jns	.L5
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L6
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	jne	.L7
.L6:
	jmp	.L8
.L7:
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$10, %eax
	je	.L9
	movl	$.LC1, 4(%esp)
	movl	$3, (%esp)
	call	syslog
	jmp	.L4
.L9:
	jmp	.L4
.L5:
	movl	hs, %eax
	testl	%eax, %eax
	je	.L8
	movl	hs, %eax
	movl	20(%eax), %edx
	subl	$1, %edx
	movl	%edx, 20(%eax)
	movl	hs, %eax
	movl	20(%eax), %eax
	testl	%eax, %eax
	jns	.L8
	movl	hs, %eax
	movl	$0, 20(%eax)
	jmp	.L10
.L8:
	jmp	.L10
.L4:
	call	__errno_location
	movl	-16(%ebp), %edx
	movl	%edx, (%eax)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	handle_chld, .-handle_chld
	.type	handle_hup, @function
handle_hup:
.LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	$1, got_hup
	call	__errno_location
	movl	-12(%ebp), %edx
	movl	%edx, (%eax)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE2:
	.size	handle_hup, .-handle_hup
	.section	.rodata
.LC2:
	.string	"exiting"
	.text
	.type	handle_usr1, @function
handle_usr1:
.LFB3:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	num_connects, %eax
	testl	%eax, %eax
	jne	.L13
	call	shut_down
	movl	$.LC2, 4(%esp)
	movl	$5, (%esp)
	call	syslog
	call	closelog
	movl	$0, (%esp)
	call	exit
.L13:
	movl	$1, got_usr1
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE3:
	.size	handle_usr1, .-handle_usr1
	.type	handle_usr2, @function
handle_usr2:
.LFB4:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	$0, (%esp)
	call	logstats
	call	__errno_location
	movl	-12(%ebp), %edx
	movl	%edx, (%eax)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE4:
	.size	handle_usr2, .-handle_usr2
	.section	.rodata
.LC3:
	.string	"/tmp"
	.text
	.type	handle_alrm, @function
handle_alrm:
.LFB5:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	watchdog_flag, %eax
	testl	%eax, %eax
	jne	.L16
	movl	$.LC3, (%esp)
	call	chdir
	call	abort
.L16:
	movl	$0, watchdog_flag
	movl	$360, (%esp)
	call	alarm
	call	__errno_location
	movl	-12(%ebp), %edx
	movl	%edx, (%eax)
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE5:
	.size	handle_alrm, .-handle_alrm
	.section	.rodata
.LC4:
	.string	"-"
.LC5:
	.string	"re-opening logfile"
.LC6:
	.string	"a"
.LC7:
	.string	"re-opening %.80s - %m"
	.text
	.type	re_open_logfile, @function
re_open_logfile:
.LFB6:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	no_log, %eax
	testl	%eax, %eax
	jne	.L18
	movl	hs, %eax
	testl	%eax, %eax
	jne	.L19
.L18:
	jmp	.L17
.L19:
	movl	logfile, %eax
	testl	%eax, %eax
	je	.L17
	movl	logfile, %eax
	movl	$.LC4, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	je	.L17
	movl	$.LC5, 4(%esp)
	movl	$5, (%esp)
	call	syslog
	movl	logfile, %eax
	movl	$.LC6, 4(%esp)
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L21
	movl	logfile, %eax
	movl	%eax, 8(%esp)
	movl	$.LC7, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	jmp	.L17
.L21:
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	fileno
	movl	$1, 8(%esp)
	movl	$2, 4(%esp)
	movl	%eax, (%esp)
	call	fcntl
	movl	hs, %eax
	movl	-12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	httpd_set_logfp
.L17:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE6:
	.size	re_open_logfile, .-re_open_logfile
	.section	.rodata
.LC8:
	.string	"can't find any valid address"
	.align 4
.LC9:
	.string	"%s: can't find any valid address\n"
.LC10:
	.string	"unknown user - '%.80s'"
.LC11:
	.string	"%s: unknown user - '%s'\n"
.LC12:
	.string	"/dev/null"
.LC13:
	.string	"%.80s - %m"
	.align 4
.LC14:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.align 4
.LC15:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
.LC16:
	.string	"fchown logfile - %m"
.LC17:
	.string	"fchown logfile"
.LC18:
	.string	"chdir - %m"
.LC19:
	.string	"chdir"
.LC20:
	.string	"daemon - %m"
.LC21:
	.string	"w"
.LC22:
	.string	"%d\n"
	.align 4
.LC23:
	.string	"fdwatch initialization failure"
.LC24:
	.string	"chroot - %m"
.LC25:
	.string	"chroot"
	.align 4
.LC26:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.align 4
.LC27:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
.LC28:
	.string	"chroot chdir - %m"
.LC29:
	.string	"chroot chdir"
.LC30:
	.string	"data_dir chdir - %m"
.LC31:
	.string	"data_dir chdir"
.LC32:
	.string	"tmr_create(occasional) failed"
.LC33:
	.string	"tmr_create(idle) failed"
	.align 4
.LC34:
	.string	"tmr_create(update_throttles) failed"
.LC35:
	.string	"tmr_create(show_stats) failed"
.LC36:
	.string	"setgroups - %m"
.LC37:
	.string	"setgid - %m"
.LC38:
	.string	"initgroups - %m"
.LC39:
	.string	"setuid - %m"
	.align 4
.LC40:
	.string	"started as root without requesting chroot(), warning only"
	.align 4
.LC41:
	.string	"out of memory allocating a connecttab"
.LC42:
	.string	"fdwatch - %m"
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	andl	$-16, %esp
	subl	$4544, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movl	12(%ebp), %eax
	movl	%eax, 124(%esp)
	movl	%gs:20, %eax
	movl	%eax, 4540(%esp)
	xorl	%eax, %eax
	movl	$32767, 140(%esp)
	movl	$32767, 144(%esp)
	movl	124(%esp), %eax
	movl	(%eax), %eax
	movl	%eax, argv0
	movl	argv0, %eax
	movl	$47, 4(%esp)
	movl	%eax, (%esp)
	call	strrchr
	movl	%eax, 136(%esp)
	cmpl	$0, 136(%esp)
	je	.L23
	addl	$1, 136(%esp)
	jmp	.L24
.L23:
	movl	argv0, %eax
	movl	%eax, 136(%esp)
.L24:
	movl	$24, 8(%esp)
	movl	$9, 4(%esp)
	movl	136(%esp), %eax
	movl	%eax, (%esp)
	call	openlog
	movl	124(%esp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_args
	call	tzset
	leal	132(%esp), %eax
	movl	%eax, 20(%esp)
	movl	$128, 16(%esp)
	leal	312(%esp), %eax
	movl	%eax, 12(%esp)
	leal	128(%esp), %eax
	movl	%eax, 8(%esp)
	movl	$128, 4(%esp)
	leal	184(%esp), %eax
	movl	%eax, (%esp)
	call	lookup_hostname
	movl	128(%esp), %eax
	testl	%eax, %eax
	jne	.L25
	movl	132(%esp), %eax
	testl	%eax, %eax
	jne	.L25
	movl	$.LC8, 4(%esp)
	movl	$3, (%esp)
	call	syslog
	movl	argv0, %edx
	movl	stderr, %eax
	movl	%edx, 8(%esp)
	movl	$.LC9, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L25:
	movl	$0, numthrottles
	movl	$0, maxthrottles
	movl	$0, throttles
	movl	throttlefile, %eax
	testl	%eax, %eax
	je	.L26
	movl	throttlefile, %eax
	movl	%eax, (%esp)
	call	read_throttlefile
.L26:
	call	getuid
	testl	%eax, %eax
	jne	.L27
	movl	user, %eax
	movl	%eax, (%esp)
	call	getpwnam
	movl	%eax, 156(%esp)
	cmpl	$0, 156(%esp)
	jne	.L28
	movl	user, %eax
	movl	%eax, 8(%esp)
	movl	$.LC10, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	user, %ecx
	movl	argv0, %edx
	movl	stderr, %eax
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC11, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L28:
	movl	156(%esp), %eax
	movl	8(%eax), %eax
	movl	%eax, 140(%esp)
	movl	156(%esp), %eax
	movl	12(%eax), %eax
	movl	%eax, 144(%esp)
.L27:
	movl	logfile, %eax
	testl	%eax, %eax
	je	.L29
	movl	logfile, %eax
	movl	$.LC12, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L30
	movl	$1, no_log
	movl	$0, 148(%esp)
	jmp	.L35
.L30:
	movl	logfile, %eax
	movl	$.LC4, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L32
	movl	stdout, %eax
	movl	%eax, 148(%esp)
	jmp	.L35
.L32:
	movl	logfile, %eax
	movl	$.LC6, 4(%esp)
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, 148(%esp)
	cmpl	$0, 148(%esp)
	jne	.L33
	movl	logfile, %eax
	movl	%eax, 8(%esp)
	movl	$.LC13, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	logfile, %eax
	movl	%eax, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L33:
	movl	logfile, %eax
	movzbl	(%eax), %eax
	cmpb	$47, %al
	je	.L34
	movl	$.LC14, 4(%esp)
	movl	$4, (%esp)
	call	syslog
	movl	argv0, %edx
	movl	stderr, %eax
	movl	%edx, 8(%esp)
	movl	$.LC15, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
.L34:
	movl	148(%esp), %eax
	movl	%eax, (%esp)
	call	fileno
	movl	$1, 8(%esp)
	movl	$2, 4(%esp)
	movl	%eax, (%esp)
	call	fcntl
	call	getuid
	testl	%eax, %eax
	jne	.L35
	movl	148(%esp), %eax
	movl	%eax, (%esp)
	call	fileno
	movl	144(%esp), %edx
	movl	%edx, 8(%esp)
	movl	140(%esp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	fchown
	testl	%eax, %eax
	jns	.L35
	movl	$.LC16, 4(%esp)
	movl	$4, (%esp)
	call	syslog
	movl	$.LC17, (%esp)
	call	perror
	jmp	.L35
.L29:
	movl	$0, 148(%esp)
.L35:
	movl	dir, %eax
	testl	%eax, %eax
	je	.L36
	movl	dir, %eax
	movl	%eax, (%esp)
	call	chdir
	testl	%eax, %eax
	jns	.L36
	movl	$.LC18, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$.LC19, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L36:
	movl	$4096, 4(%esp)
	leal	443(%esp), %eax
	movl	%eax, (%esp)
	call	getcwd
	leal	443(%esp), %eax
	movl	%eax, (%esp)
	call	strlen
	subl	$1, %eax
	movzbl	443(%esp,%eax), %eax
	cmpb	$47, %al
	je	.L37
	leal	443(%esp), %eax
	movl	$-1, %ecx
	movl	%eax, %edx
	movl	$0, %eax
	movl	%edx, %edi
	repnz; scasb
	movl	%ecx, %eax
	notl	%eax
	leal	-1(%eax), %edx
	leal	443(%esp), %eax
	addl	%edx, %eax
	movw	$47, (%eax)
.L37:
	movl	debug, %eax
	testl	%eax, %eax
	jne	.L38
	movl	stdin, %eax
	movl	%eax, (%esp)
	call	fclose
	movl	stdout, %eax
	cmpl	%eax, 148(%esp)
	je	.L39
	movl	stdout, %eax
	movl	%eax, (%esp)
	call	fclose
.L39:
	movl	stderr, %eax
	movl	%eax, (%esp)
	call	fclose
	movl	$1, 4(%esp)
	movl	$1, (%esp)
	call	daemon
	testl	%eax, %eax
	jns	.L40
	movl	$.LC20, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L38:
	call	setsid
.L40:
	movl	pidfile, %eax
	testl	%eax, %eax
	je	.L41
	movl	pidfile, %eax
	movl	$.LC21, 4(%esp)
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, 160(%esp)
	cmpl	$0, 160(%esp)
	jne	.L42
	movl	pidfile, %eax
	movl	%eax, 8(%esp)
	movl	$.LC13, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L42:
	call	getpid
	movl	%eax, 8(%esp)
	movl	$.LC22, 4(%esp)
	movl	160(%esp), %eax
	movl	%eax, (%esp)
	call	fprintf
	movl	160(%esp), %eax
	movl	%eax, (%esp)
	call	fclose
.L41:
	call	fdwatch_get_nfiles
	movl	%eax, max_connects
	movl	max_connects, %eax
	testl	%eax, %eax
	jns	.L43
	movl	$.LC23, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L43:
	movl	max_connects, %eax
	subl	$10, %eax
	movl	%eax, max_connects
	movl	do_chroot, %eax
	testl	%eax, %eax
	je	.L44
	leal	443(%esp), %eax
	movl	%eax, (%esp)
	call	chroot
	testl	%eax, %eax
	jns	.L45
	movl	$.LC24, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$.LC25, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L45:
	movl	logfile, %eax
	testl	%eax, %eax
	je	.L46
	movl	logfile, %eax
	movl	$.LC4, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	je	.L46
	leal	443(%esp), %eax
	movl	%eax, (%esp)
	call	strlen
	movl	logfile, %edx
	movl	%eax, 8(%esp)
	leal	443(%esp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	strncmp
	testl	%eax, %eax
	jne	.L47
	movl	logfile, %ebx
	leal	443(%esp), %eax
	movl	%eax, (%esp)
	call	strlen
	subl	$1, %eax
	leal	(%ebx,%eax), %edx
	movl	logfile, %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	strcpy
	jmp	.L46
.L47:
	movl	$.LC26, 4(%esp)
	movl	$4, (%esp)
	call	syslog
	movl	argv0, %edx
	movl	stderr, %eax
	movl	%edx, 8(%esp)
	movl	$.LC27, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
.L46:
	leal	443(%esp), %eax
	movw	$47, (%eax)
	leal	443(%esp), %eax
	movl	%eax, (%esp)
	call	chdir
	testl	%eax, %eax
	jns	.L44
	movl	$.LC28, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$.LC29, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L44:
	movl	data_dir, %eax
	testl	%eax, %eax
	je	.L48
	movl	data_dir, %eax
	movl	%eax, (%esp)
	call	chdir
	testl	%eax, %eax
	jns	.L48
	movl	$.LC30, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$.LC31, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L48:
	movl	$handle_term, 4(%esp)
	movl	$15, (%esp)
	call	sigset
	movl	$handle_term, 4(%esp)
	movl	$2, (%esp)
	call	sigset
	movl	$handle_chld, 4(%esp)
	movl	$17, (%esp)
	call	sigset
	movl	$1, 4(%esp)
	movl	$13, (%esp)
	call	sigset
	movl	$handle_hup, 4(%esp)
	movl	$1, (%esp)
	call	sigset
	movl	$handle_usr1, 4(%esp)
	movl	$10, (%esp)
	call	sigset
	movl	$handle_usr2, 4(%esp)
	movl	$12, (%esp)
	call	sigset
	movl	$handle_alrm, 4(%esp)
	movl	$14, (%esp)
	call	sigset
	movl	$0, got_hup
	movl	$0, got_usr1
	movl	$0, watchdog_flag
	movl	$360, (%esp)
	call	alarm
	call	tmr_init
	movl	no_empty_referers, %esi
	movl	local_pattern, %edi
	movl	url_pattern, %eax
	movl	%eax, 120(%esp)
	movl	do_global_passwd, %eax
	movl	%eax, 116(%esp)
	movl	do_vhost, %eax
	movl	%eax, 112(%esp)
	movl	no_symlink_check, %eax
	movl	%eax, 108(%esp)
	movl	no_log, %eax
	movl	%eax, 104(%esp)
	movl	max_age, %eax
	movl	%eax, 100(%esp)
	movl	p3p, %eax
	movl	%eax, 96(%esp)
	movl	charset, %eax
	movl	%eax, 92(%esp)
	movl	cgi_limit, %eax
	movl	%eax, 88(%esp)
	movl	cgi_pattern, %eax
	movl	%eax, 84(%esp)
	movzwl	port, %eax
	movzwl	%ax, %eax
	movl	%eax, 80(%esp)
	movl	132(%esp), %eax
	testl	%eax, %eax
	je	.L49
	leal	312(%esp), %ebx
	jmp	.L50
.L49:
	movl	$0, %ebx
.L50:
	movl	128(%esp), %eax
	testl	%eax, %eax
	je	.L51
	leal	184(%esp), %edx
	jmp	.L52
.L51:
	movl	$0, %edx
.L52:
	movl	hostname, %ecx
	movl	%esi, 68(%esp)
	movl	%edi, 64(%esp)
	movl	120(%esp), %eax
	movl	%eax, 60(%esp)
	movl	116(%esp), %eax
	movl	%eax, 56(%esp)
	movl	112(%esp), %eax
	movl	%eax, 52(%esp)
	movl	108(%esp), %eax
	movl	%eax, 48(%esp)
	movl	148(%esp), %eax
	movl	%eax, 44(%esp)
	movl	104(%esp), %eax
	movl	%eax, 40(%esp)
	leal	443(%esp), %eax
	movl	%eax, 36(%esp)
	movl	100(%esp), %eax
	movl	%eax, 32(%esp)
	movl	96(%esp), %eax
	movl	%eax, 28(%esp)
	movl	92(%esp), %eax
	movl	%eax, 24(%esp)
	movl	88(%esp), %eax
	movl	%eax, 20(%esp)
	movl	84(%esp), %eax
	movl	%eax, 16(%esp)
	movl	80(%esp), %eax
	movl	%eax, 12(%esp)
	movl	%ebx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	httpd_initialize
	movl	%eax, hs
	movl	hs, %eax
	testl	%eax, %eax
	jne	.L53
	movl	$1, (%esp)
	call	exit
.L53:
	movl	$1, 16(%esp)
	movl	$120000, 12(%esp)
	movl	JunkClientData, %eax
	movl	%eax, 8(%esp)
	movl	$occasional, 4(%esp)
	movl	$0, (%esp)
	call	tmr_create
	testl	%eax, %eax
	jne	.L54
	movl	$.LC32, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L54:
	movl	$1, 16(%esp)
	movl	$5000, 12(%esp)
	movl	JunkClientData, %eax
	movl	%eax, 8(%esp)
	movl	$idle, 4(%esp)
	movl	$0, (%esp)
	call	tmr_create
	testl	%eax, %eax
	jne	.L55
	movl	$.LC33, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L55:
	movl	numthrottles, %eax
	testl	%eax, %eax
	jle	.L56
	movl	$1, 16(%esp)
	movl	$2000, 12(%esp)
	movl	JunkClientData, %eax
	movl	%eax, 8(%esp)
	movl	$update_throttles, 4(%esp)
	movl	$0, (%esp)
	call	tmr_create
	testl	%eax, %eax
	jne	.L56
	movl	$.LC34, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L56:
	movl	$1, 16(%esp)
	movl	$3600000, 12(%esp)
	movl	JunkClientData, %eax
	movl	%eax, 8(%esp)
	movl	$show_stats, 4(%esp)
	movl	$0, (%esp)
	call	tmr_create
	testl	%eax, %eax
	jne	.L57
	movl	$.LC35, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L57:
	movl	$0, (%esp)
	call	time
	movl	%eax, stats_time
	movl	stats_time, %eax
	movl	%eax, start_time
	movl	$0, stats_connections
	movl	$0, stats_bytes
	movl	$0, stats_simultaneous
	call	getuid
	testl	%eax, %eax
	jne	.L58
	movl	$0, 4(%esp)
	movl	$0, (%esp)
	call	setgroups
	testl	%eax, %eax
	jns	.L59
	movl	$.LC36, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L59:
	movl	144(%esp), %eax
	movl	%eax, (%esp)
	call	setgid
	testl	%eax, %eax
	jns	.L60
	movl	$.LC37, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L60:
	movl	user, %eax
	movl	144(%esp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	initgroups
	testl	%eax, %eax
	jns	.L61
	movl	$.LC38, 4(%esp)
	movl	$4, (%esp)
	call	syslog
.L61:
	movl	140(%esp), %eax
	movl	%eax, (%esp)
	call	setuid
	testl	%eax, %eax
	jns	.L62
	movl	$.LC39, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L62:
	movl	do_chroot, %eax
	testl	%eax, %eax
	jne	.L58
	movl	$.LC40, 4(%esp)
	movl	$4, (%esp)
	call	syslog
.L58:
	movl	max_connects, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	movl	%eax, (%esp)
	call	malloc
	movl	%eax, connects
	movl	connects, %eax
	testl	%eax, %eax
	jne	.L63
	movl	$.LC41, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L63:
	movl	$0, 152(%esp)
	jmp	.L64
.L65:
	movl	connects, %ecx
	movl	152(%esp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	$0, (%eax)
	movl	connects, %ecx
	movl	152(%esp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	152(%esp), %edx
	addl	$1, %edx
	movl	%edx, 4(%eax)
	movl	connects, %ecx
	movl	152(%esp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	$0, 8(%eax)
	addl	$1, 152(%esp)
.L64:
	movl	max_connects, %eax
	cmpl	%eax, 152(%esp)
	jl	.L65
	movl	connects, %ecx
	movl	max_connects, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	subl	$96, %eax
	addl	%ecx, %eax
	movl	$-1, 4(%eax)
	movl	$0, first_free_connect
	movl	$0, num_connects
	movl	$0, httpd_conn_count
	movl	hs, %eax
	testl	%eax, %eax
	je	.L66
	movl	hs, %eax
	movl	40(%eax), %eax
	cmpl	$-1, %eax
	je	.L67
	movl	hs, %eax
	movl	40(%eax), %eax
	movl	$0, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	fdwatch_add_fd
.L67:
	movl	hs, %eax
	movl	44(%eax), %eax
	cmpl	$-1, %eax
	je	.L66
	movl	hs, %eax
	movl	44(%eax), %eax
	movl	$0, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	fdwatch_add_fd
.L66:
	leal	176(%esp), %eax
	movl	%eax, (%esp)
	call	tmr_prepare_timeval
	jmp	.L68
.L85:
	movl	got_hup, %eax
	testl	%eax, %eax
	je	.L69
	call	re_open_logfile
	movl	$0, got_hup
.L69:
	leal	176(%esp), %eax
	movl	%eax, (%esp)
	call	tmr_mstimeout
	movl	%eax, (%esp)
	call	fdwatch
	movl	%eax, 164(%esp)
	cmpl	$0, 164(%esp)
	jns	.L70
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L71
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	jne	.L72
.L71:
	jmp	.L68
.L72:
	movl	$.LC42, 4(%esp)
	movl	$3, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L70:
	leal	176(%esp), %eax
	movl	%eax, (%esp)
	call	tmr_prepare_timeval
	cmpl	$0, 164(%esp)
	jne	.L73
	leal	176(%esp), %eax
	movl	%eax, (%esp)
	call	tmr_run
	jmp	.L68
.L73:
	movl	hs, %eax
	testl	%eax, %eax
	je	.L74
	movl	hs, %eax
	movl	44(%eax), %eax
	cmpl	$-1, %eax
	je	.L74
	movl	hs, %eax
	movl	44(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L74
	movl	hs, %eax
	movl	44(%eax), %eax
	movl	%eax, 4(%esp)
	leal	176(%esp), %eax
	movl	%eax, (%esp)
	call	handle_newconnect
	testl	%eax, %eax
	je	.L74
	jmp	.L68
.L74:
	movl	hs, %eax
	testl	%eax, %eax
	je	.L75
	movl	hs, %eax
	movl	40(%eax), %eax
	cmpl	$-1, %eax
	je	.L75
	movl	hs, %eax
	movl	40(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L75
	movl	hs, %eax
	movl	40(%eax), %eax
	movl	%eax, 4(%esp)
	leal	176(%esp), %eax
	movl	%eax, (%esp)
	call	handle_newconnect
	testl	%eax, %eax
	je	.L75
	jmp	.L68
.L75:
	jmp	.L76
.L82:
	cmpl	$0, 168(%esp)
	jne	.L77
	jmp	.L76
.L77:
	movl	168(%esp), %eax
	movl	8(%eax), %eax
	movl	%eax, 172(%esp)
	movl	172(%esp), %eax
	movl	448(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L78
	leal	176(%esp), %eax
	movl	%eax, 4(%esp)
	movl	168(%esp), %eax
	movl	%eax, (%esp)
	call	clear_connection
	jmp	.L76
.L78:
	movl	168(%esp), %eax
	movl	(%eax), %eax
	cmpl	$2, %eax
	je	.L79
	cmpl	$4, %eax
	je	.L80
	cmpl	$1, %eax
	jne	.L76
	leal	176(%esp), %eax
	movl	%eax, 4(%esp)
	movl	168(%esp), %eax
	movl	%eax, (%esp)
	call	handle_read
	jmp	.L76
.L79:
	leal	176(%esp), %eax
	movl	%eax, 4(%esp)
	movl	168(%esp), %eax
	movl	%eax, (%esp)
	call	handle_send
	jmp	.L76
.L80:
	leal	176(%esp), %eax
	movl	%eax, 4(%esp)
	movl	168(%esp), %eax
	movl	%eax, (%esp)
	call	handle_linger
	nop
.L76:
	call	fdwatch_get_next_client_data
	movl	%eax, 168(%esp)
	cmpl	$-1, 168(%esp)
	jne	.L82
	leal	176(%esp), %eax
	movl	%eax, (%esp)
	call	tmr_run
	movl	got_usr1, %eax
	testl	%eax, %eax
	je	.L68
	movl	terminate, %eax
	testl	%eax, %eax
	jne	.L68
	movl	$1, terminate
	movl	hs, %eax
	testl	%eax, %eax
	je	.L68
	movl	hs, %eax
	movl	40(%eax), %eax
	cmpl	$-1, %eax
	je	.L83
	movl	hs, %eax
	movl	40(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
.L83:
	movl	hs, %eax
	movl	44(%eax), %eax
	cmpl	$-1, %eax
	je	.L84
	movl	hs, %eax
	movl	44(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
.L84:
	movl	hs, %eax
	movl	%eax, (%esp)
	call	httpd_unlisten
.L68:
	movl	terminate, %eax
	testl	%eax, %eax
	je	.L85
	movl	num_connects, %eax
	testl	%eax, %eax
	jg	.L85
	call	shut_down
	movl	$.LC2, 4(%esp)
	movl	$5, (%esp)
	call	syslog
	call	closelog
	movl	$0, (%esp)
	call	exit
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.section	.rodata
.LC43:
	.string	"nobody"
.LC44:
	.string	"iso-8859-1"
.LC45:
	.string	""
.LC46:
	.string	"-V"
.LC47:
	.string	"thttpd/2.26.2 April 4, 2012"
.LC48:
	.string	"-C"
.LC49:
	.string	"-p"
.LC50:
	.string	"-d"
.LC51:
	.string	"-r"
.LC52:
	.string	"-nor"
.LC53:
	.string	"-dd"
.LC54:
	.string	"-s"
.LC55:
	.string	"-nos"
.LC56:
	.string	"-u"
.LC57:
	.string	"-c"
.LC58:
	.string	"-t"
.LC59:
	.string	"-h"
.LC60:
	.string	"-l"
.LC61:
	.string	"-v"
.LC62:
	.string	"-nov"
.LC63:
	.string	"-g"
.LC64:
	.string	"-nog"
.LC65:
	.string	"-i"
.LC66:
	.string	"-T"
.LC67:
	.string	"-P"
.LC68:
	.string	"-M"
.LC69:
	.string	"-D"
	.text
	.type	parse_args, @function
parse_args:
.LFB8:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$0, debug
	movw	$80, port
	movl	$0, dir
	movl	$0, data_dir
	movl	$0, do_chroot
	movl	$0, no_log
	movl	do_chroot, %eax
	movl	%eax, no_symlink_check
	movl	$0, do_vhost
	movl	$0, do_global_passwd
	movl	$0, cgi_pattern
	movl	$0, cgi_limit
	movl	$0, url_pattern
	movl	$0, no_empty_referers
	movl	$0, local_pattern
	movl	$0, throttlefile
	movl	$0, hostname
	movl	$0, logfile
	movl	$0, pidfile
	movl	$.LC43, user
	movl	$.LC44, charset
	movl	$.LC45, p3p
	movl	$-1, max_age
	movl	$1, -12(%ebp)
	jmp	.L88
.L114:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC46, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L89
	movl	$.LC47, (%esp)
	call	puts
	movl	$0, (%esp)
	call	exit
.L89:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC48, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L90
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L90
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	read_config
	jmp	.L91
.L90:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC49, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L92
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L92
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	atoi
	movw	%ax, port
	jmp	.L91
.L92:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC50, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L93
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L93
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, dir
	jmp	.L91
.L93:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC51, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L94
	movl	$1, do_chroot
	movl	$1, no_symlink_check
	jmp	.L91
.L94:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC52, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L95
	movl	$0, do_chroot
	movl	$0, no_symlink_check
	jmp	.L91
.L95:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC53, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L96
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L96
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, data_dir
	jmp	.L91
.L96:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC54, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L97
	movl	$0, no_symlink_check
	jmp	.L91
.L97:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC55, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L98
	movl	$1, no_symlink_check
	jmp	.L91
.L98:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC56, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L99
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L99
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, user
	jmp	.L91
.L99:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC57, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L100
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L100
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, cgi_pattern
	jmp	.L91
.L100:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC58, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L101
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L101
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, throttlefile
	jmp	.L91
.L101:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC59, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L102
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L102
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, hostname
	jmp	.L91
.L102:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC60, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L103
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L103
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, logfile
	jmp	.L91
.L103:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC61, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L104
	movl	$1, do_vhost
	jmp	.L91
.L104:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC62, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L105
	movl	$0, do_vhost
	jmp	.L91
.L105:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC63, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L106
	movl	$1, do_global_passwd
	jmp	.L91
.L106:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC64, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L107
	movl	$0, do_global_passwd
	jmp	.L91
.L107:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC65, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L108
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L108
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, pidfile
	jmp	.L91
.L108:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC66, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L109
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L109
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, charset
	jmp	.L91
.L109:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC67, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L110
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L110
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, p3p
	jmp	.L91
.L110:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC68, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L111
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L111
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	atoi
	movl	%eax, max_age
	jmp	.L91
.L111:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC69, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L112
	movl	$1, debug
	jmp	.L91
.L112:
	call	usage
.L91:
	addl	$1, -12(%ebp)
.L88:
	movl	-12(%ebp), %eax
	cmpl	8(%ebp), %eax
	jge	.L113
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movzbl	(%eax), %eax
	cmpb	$45, %al
	je	.L114
.L113:
	movl	-12(%ebp), %eax
	cmpl	8(%ebp), %eax
	je	.L87
	call	usage
.L87:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE8:
	.size	parse_args, .-parse_args
	.section	.rodata
	.align 4
.LC70:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor] [-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat] [-t throttles] [-h host] [-l logfile] [-i pidfile] [-T charset] [-P P3P] [-M maxage] [-V] [-D]\n"
	.text
	.type	usage, @function
usage:
.LFB9:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	argv0, %edx
	movl	stderr, %eax
	movl	%edx, 8(%esp)
	movl	$.LC70, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	movl	$1, (%esp)
	call	exit
	.cfi_endproc
.LFE9:
	.size	usage, .-usage
	.section	.rodata
.LC71:
	.string	"r"
.LC72:
	.string	" \t\n\r"
.LC73:
	.string	"debug"
.LC74:
	.string	"port"
.LC75:
	.string	"dir"
.LC76:
	.string	"nochroot"
.LC77:
	.string	"data_dir"
.LC78:
	.string	"symlink"
.LC79:
	.string	"nosymlink"
.LC80:
	.string	"symlinks"
.LC81:
	.string	"nosymlinks"
.LC82:
	.string	"user"
.LC83:
	.string	"cgipat"
.LC84:
	.string	"cgilimit"
.LC85:
	.string	"urlpat"
.LC86:
	.string	"noemptyreferers"
.LC87:
	.string	"localpat"
.LC88:
	.string	"throttles"
.LC89:
	.string	"host"
.LC90:
	.string	"logfile"
.LC91:
	.string	"vhost"
.LC92:
	.string	"novhost"
.LC93:
	.string	"globalpasswd"
.LC94:
	.string	"noglobalpasswd"
.LC95:
	.string	"pidfile"
.LC96:
	.string	"charset"
.LC97:
	.string	"p3p"
.LC98:
	.string	"max_age"
	.align 4
.LC99:
	.string	"%s: unknown config option '%s'\n"
	.text
	.type	read_config, @function
read_config:
.LFB10:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$10072, %esp
	movl	8(%ebp), %eax
	movl	%eax, -10044(%ebp)
	movl	%gs:20, %eax
	movl	%eax, -12(%ebp)
	xorl	%eax, %eax
	movl	$.LC71, 4(%esp)
	movl	-10044(%ebp), %eax
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, -10020(%ebp)
	cmpl	$0, -10020(%ebp)
	jne	.L118
	movl	-10044(%ebp), %eax
	movl	%eax, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L118:
	jmp	.L119
.L154:
	movl	$35, 4(%esp)
	leal	-10012(%ebp), %eax
	movl	%eax, (%esp)
	call	strchr
	movl	%eax, -10032(%ebp)
	cmpl	$0, -10032(%ebp)
	je	.L120
	movl	-10032(%ebp), %eax
	movb	$0, (%eax)
.L120:
	leal	-10012(%ebp), %eax
	movl	%eax, -10032(%ebp)
	movl	$.LC72, 4(%esp)
	movl	-10032(%ebp), %eax
	movl	%eax, (%esp)
	call	strspn
	addl	%eax, -10032(%ebp)
	jmp	.L121
.L153:
	movl	$.LC72, 4(%esp)
	movl	-10032(%ebp), %eax
	movl	%eax, (%esp)
	call	strcspn
	movl	-10032(%ebp), %edx
	addl	%edx, %eax
	movl	%eax, -10028(%ebp)
	jmp	.L122
.L123:
	movl	-10028(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -10028(%ebp)
	movb	$0, (%eax)
.L122:
	movl	-10028(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$32, %al
	je	.L123
	movl	-10028(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$9, %al
	je	.L123
	movl	-10028(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$10, %al
	je	.L123
	movl	-10028(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$13, %al
	je	.L123
	movl	-10032(%ebp), %eax
	movl	%eax, -10016(%ebp)
	movl	$61, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strchr
	movl	%eax, -10024(%ebp)
	cmpl	$0, -10024(%ebp)
	je	.L124
	movl	-10024(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -10024(%ebp)
	movb	$0, (%eax)
.L124:
	movl	$.LC73, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L125
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, debug
	jmp	.L126
.L125:
	movl	$.LC74, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L127
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	atoi
	movw	%ax, port
	jmp	.L126
.L127:
	movl	$.LC75, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L128
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, dir
	jmp	.L126
.L128:
	movl	$.LC25, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L129
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, do_chroot
	movl	$1, no_symlink_check
	jmp	.L126
.L129:
	movl	$.LC76, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L130
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$0, do_chroot
	movl	$0, no_symlink_check
	jmp	.L126
.L130:
	movl	$.LC77, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L131
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, data_dir
	jmp	.L126
.L131:
	movl	$.LC78, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L132
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$0, no_symlink_check
	jmp	.L126
.L132:
	movl	$.LC79, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L133
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, no_symlink_check
	jmp	.L126
.L133:
	movl	$.LC80, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L134
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$0, no_symlink_check
	jmp	.L126
.L134:
	movl	$.LC81, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L135
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, no_symlink_check
	jmp	.L126
.L135:
	movl	$.LC82, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L136
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, user
	jmp	.L126
.L136:
	movl	$.LC83, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L137
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, cgi_pattern
	jmp	.L126
.L137:
	movl	$.LC84, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L138
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	atoi
	movl	%eax, cgi_limit
	jmp	.L126
.L138:
	movl	$.LC85, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L139
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, url_pattern
	jmp	.L126
.L139:
	movl	$.LC86, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L140
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, no_empty_referers
	jmp	.L126
.L140:
	movl	$.LC87, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L141
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, local_pattern
	jmp	.L126
.L141:
	movl	$.LC88, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L142
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, throttlefile
	jmp	.L126
.L142:
	movl	$.LC89, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L143
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, hostname
	jmp	.L126
.L143:
	movl	$.LC90, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L144
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, logfile
	jmp	.L126
.L144:
	movl	$.LC91, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L145
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, do_vhost
	jmp	.L126
.L145:
	movl	$.LC92, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L146
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$0, do_vhost
	jmp	.L126
.L146:
	movl	$.LC93, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L147
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, do_global_passwd
	jmp	.L126
.L147:
	movl	$.LC94, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L148
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$0, do_global_passwd
	jmp	.L126
.L148:
	movl	$.LC95, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L149
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, pidfile
	jmp	.L126
.L149:
	movl	$.LC96, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L150
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, charset
	jmp	.L126
.L150:
	movl	$.LC97, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L151
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, p3p
	jmp	.L126
.L151:
	movl	$.LC98, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L152
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-10016(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-10024(%ebp), %eax
	movl	%eax, (%esp)
	call	atoi
	movl	%eax, max_age
	jmp	.L126
.L152:
	movl	argv0, %edx
	movl	stderr, %eax
	movl	-10016(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC99, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L126:
	movl	-10028(%ebp), %eax
	movl	%eax, -10032(%ebp)
	movl	$.LC72, 4(%esp)
	movl	-10032(%ebp), %eax
	movl	%eax, (%esp)
	call	strspn
	addl	%eax, -10032(%ebp)
.L121:
	movl	-10032(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L153
.L119:
	movl	-10020(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$10000, 4(%esp)
	leal	-10012(%ebp), %eax
	movl	%eax, (%esp)
	call	fgets
	testl	%eax, %eax
	jne	.L154
	movl	-10020(%ebp), %eax
	movl	%eax, (%esp)
	call	fclose
	movl	-12(%ebp), %eax
	xorl	%gs:20, %eax
	je	.L155
	call	__stack_chk_fail
.L155:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE10:
	.size	read_config, .-read_config
	.section	.rodata
	.align 4
.LC100:
	.string	"%s: value required for %s option\n"
	.text
	.type	value_required, @function
value_required:
.LFB11:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	cmpl	$0, 12(%ebp)
	jne	.L156
	movl	argv0, %edx
	movl	stderr, %eax
	movl	8(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC100, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L156:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE11:
	.size	value_required, .-value_required
	.section	.rodata
	.align 4
.LC101:
	.string	"%s: no value required for %s option\n"
	.text
	.type	no_value_required, @function
no_value_required:
.LFB12:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	cmpl	$0, 12(%ebp)
	je	.L158
	movl	argv0, %edx
	movl	stderr, %eax
	movl	8(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC101, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L158:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE12:
	.size	no_value_required, .-no_value_required
	.section	.rodata
	.align 4
.LC102:
	.string	"out of memory copying a string"
	.align 4
.LC103:
	.string	"%s: out of memory copying a string\n"
	.text
	.type	e_strdup, @function
e_strdup:
.LFB13:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	strdup
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L161
	movl	$.LC102, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	argv0, %edx
	movl	stderr, %eax
	movl	%edx, 8(%esp)
	movl	$.LC103, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L161:
	movl	-12(%ebp), %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE13:
	.size	e_strdup, .-e_strdup
	.section	.rodata
.LC104:
	.string	"%d"
.LC105:
	.string	"getaddrinfo %.80s - %.80s"
.LC106:
	.string	"%s: getaddrinfo %s - %s\n"
	.align 4
.LC107:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.text
	.type	lookup_hostname, @function
lookup_hostname:
.LFB14:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$132, %esp
	.cfi_offset 3, -12
	movl	8(%ebp), %eax
	movl	%eax, -92(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -96(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, -100(%ebp)
	movl	28(%ebp), %eax
	movl	%eax, -104(%ebp)
	movl	%gs:20, %eax
	movl	%eax, -12(%ebp)
	xorl	%eax, %eax
	movl	$32, 8(%esp)
	movl	$0, 4(%esp)
	leal	-56(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	$0, -52(%ebp)
	movl	$1, -56(%ebp)
	movl	$1, -48(%ebp)
	movzwl	port, %eax
	movzwl	%ax, %eax
	movl	%eax, 12(%esp)
	movl	$.LC104, 8(%esp)
	movl	$10, 4(%esp)
	leal	-22(%ebp), %eax
	movl	%eax, (%esp)
	call	snprintf
	movl	hostname, %eax
	leal	-76(%ebp), %edx
	movl	%edx, 12(%esp)
	leal	-56(%ebp), %edx
	movl	%edx, 8(%esp)
	leal	-22(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	getaddrinfo
	movl	%eax, -60(%ebp)
	cmpl	$0, -60(%ebp)
	je	.L164
	movl	-60(%ebp), %eax
	movl	%eax, (%esp)
	call	gai_strerror
	movl	hostname, %edx
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC105, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	-60(%ebp), %eax
	movl	%eax, (%esp)
	call	gai_strerror
	movl	hostname, %ebx
	movl	argv0, %ecx
	movl	stderr, %edx
	movl	%eax, 16(%esp)
	movl	%ebx, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	$.LC106, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L164:
	movl	$0, -68(%ebp)
	movl	$0, -64(%ebp)
	movl	-76(%ebp), %eax
	movl	%eax, -72(%ebp)
	jmp	.L165
.L171:
	movl	-72(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	$2, %eax
	je	.L167
	cmpl	$10, %eax
	jne	.L166
	cmpl	$0, -68(%ebp)
	jne	.L169
	movl	-72(%ebp), %eax
	movl	%eax, -68(%ebp)
	jmp	.L166
.L169:
	jmp	.L166
.L167:
	cmpl	$0, -64(%ebp)
	jne	.L170
	movl	-72(%ebp), %eax
	movl	%eax, -64(%ebp)
	jmp	.L179
.L170:
.L179:
	nop
.L166:
	movl	-72(%ebp), %eax
	movl	28(%eax), %eax
	movl	%eax, -72(%ebp)
.L165:
	cmpl	$0, -72(%ebp)
	jne	.L171
	cmpl	$0, -68(%ebp)
	jne	.L172
	movl	-104(%ebp), %eax
	movl	$0, (%eax)
	jmp	.L173
.L172:
	movl	-68(%ebp), %eax
	movl	16(%eax), %eax
	cmpl	24(%ebp), %eax
	jbe	.L174
	movl	-68(%ebp), %eax
	movl	16(%eax), %edx
	movl	hostname, %eax
	movl	%edx, 16(%esp)
	movl	24(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC107, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L174:
	movl	24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	-100(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	-68(%ebp), %eax
	movl	16(%eax), %edx
	movl	-68(%ebp), %eax
	movl	20(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-100(%ebp), %eax
	movl	%eax, (%esp)
	call	memmove
	movl	-104(%ebp), %eax
	movl	$1, (%eax)
.L173:
	cmpl	$0, -64(%ebp)
	jne	.L175
	movl	-96(%ebp), %eax
	movl	$0, (%eax)
	jmp	.L176
.L175:
	movl	-64(%ebp), %eax
	movl	16(%eax), %eax
	cmpl	12(%ebp), %eax
	jbe	.L177
	movl	-64(%ebp), %eax
	movl	16(%eax), %edx
	movl	hostname, %eax
	movl	%edx, 16(%esp)
	movl	12(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC107, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L177:
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	-92(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	-64(%ebp), %eax
	movl	16(%eax), %edx
	movl	-64(%ebp), %eax
	movl	20(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-92(%ebp), %eax
	movl	%eax, (%esp)
	call	memmove
	movl	-96(%ebp), %eax
	movl	$1, (%eax)
.L176:
	movl	-76(%ebp), %eax
	movl	%eax, (%esp)
	call	freeaddrinfo
	movl	-12(%ebp), %eax
	xorl	%gs:20, %eax
	je	.L178
	call	__stack_chk_fail
.L178:
	addl	$132, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE14:
	.size	lookup_hostname, .-lookup_hostname
	.section	.rodata
.LC108:
	.string	" %4900[^ \t] %ld-%ld"
.LC109:
	.string	" %4900[^ \t] %ld"
	.align 4
.LC110:
	.string	"unparsable line in %.80s - %.80s"
	.align 4
.LC111:
	.string	"%s: unparsable line in %.80s - %.80s\n"
.LC112:
	.string	"|/"
	.align 4
.LC113:
	.string	"out of memory allocating a throttletab"
	.align 4
.LC114:
	.string	"%s: out of memory allocating a throttletab\n"
	.text
	.type	read_throttlefile, @function
read_throttlefile:
.LFB15:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$10068, %esp
	.cfi_offset 3, -12
	movl	8(%ebp), %eax
	movl	%eax, -10044(%ebp)
	movl	%gs:20, %eax
	movl	%eax, -12(%ebp)
	xorl	%eax, %eax
	movl	$.LC71, 4(%esp)
	movl	-10044(%ebp), %eax
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, -10028(%ebp)
	cmpl	$0, -10028(%ebp)
	jne	.L181
	movl	-10044(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC13, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	-10044(%ebp), %eax
	movl	%eax, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L181:
	movl	$0, 4(%esp)
	leal	-10020(%ebp), %eax
	movl	%eax, (%esp)
	call	gettimeofday
	jmp	.L182
.L196:
	movl	$35, 4(%esp)
	leal	-10012(%ebp), %eax
	movl	%eax, (%esp)
	call	strchr
	movl	%eax, -10024(%ebp)
	cmpl	$0, -10024(%ebp)
	je	.L183
	movl	-10024(%ebp), %eax
	movb	$0, (%eax)
.L183:
	leal	-10012(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	movl	%eax, -10032(%ebp)
	jmp	.L184
.L186:
	subl	$1, -10032(%ebp)
	leal	-10012(%ebp), %edx
	movl	-10032(%ebp), %eax
	addl	%edx, %eax
	movb	$0, (%eax)
.L184:
	cmpl	$0, -10032(%ebp)
	jle	.L185
	movl	-10032(%ebp), %eax
	subl	$1, %eax
	movzbl	-10012(%ebp,%eax), %eax
	cmpb	$32, %al
	je	.L186
	movl	-10032(%ebp), %eax
	subl	$1, %eax
	movzbl	-10012(%ebp,%eax), %eax
	cmpb	$9, %al
	je	.L186
	movl	-10032(%ebp), %eax
	subl	$1, %eax
	movzbl	-10012(%ebp,%eax), %eax
	cmpb	$10, %al
	je	.L186
	movl	-10032(%ebp), %eax
	subl	$1, %eax
	movzbl	-10012(%ebp,%eax), %eax
	cmpb	$13, %al
	je	.L186
.L185:
	cmpl	$0, -10032(%ebp)
	jne	.L187
	jmp	.L182
.L187:
	leal	-10040(%ebp), %eax
	movl	%eax, 16(%esp)
	leal	-10036(%ebp), %eax
	movl	%eax, 12(%esp)
	leal	-5012(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC108, 4(%esp)
	leal	-10012(%ebp), %eax
	movl	%eax, (%esp)
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L188
	leal	-10040(%ebp), %eax
	movl	%eax, 12(%esp)
	leal	-5012(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC109, 4(%esp)
	leal	-10012(%ebp), %eax
	movl	%eax, (%esp)
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L189
	movl	$0, -10036(%ebp)
	jmp	.L188
.L189:
	leal	-10012(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-10044(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC110, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	argv0, %edx
	movl	stderr, %eax
	leal	-10012(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-10044(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC111, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	jmp	.L182
.L188:
	movzbl	-5012(%ebp), %eax
	cmpb	$47, %al
	jne	.L190
	leal	-5012(%ebp), %eax
	addl	$1, %eax
	movl	%eax, 4(%esp)
	leal	-5012(%ebp), %eax
	movl	%eax, (%esp)
	call	strcpy
	jmp	.L191
.L190:
	jmp	.L191
.L192:
	movl	-10024(%ebp), %eax
	leal	2(%eax), %edx
	movl	-10024(%ebp), %eax
	addl	$1, %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	strcpy
.L191:
	movl	$.LC112, 4(%esp)
	leal	-5012(%ebp), %eax
	movl	%eax, (%esp)
	call	strstr
	movl	%eax, -10024(%ebp)
	cmpl	$0, -10024(%ebp)
	jne	.L192
	movl	numthrottles, %edx
	movl	maxthrottles, %eax
	cmpl	%eax, %edx
	jl	.L193
	movl	maxthrottles, %eax
	testl	%eax, %eax
	jne	.L194
	movl	$100, maxthrottles
	movl	maxthrottles, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, (%esp)
	call	malloc
	movl	%eax, throttles
	jmp	.L195
.L194:
	movl	maxthrottles, %eax
	addl	%eax, %eax
	movl	%eax, maxthrottles
	movl	maxthrottles, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	movl	%eax, %edx
	movl	throttles, %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	realloc
	movl	%eax, throttles
.L195:
	movl	throttles, %eax
	testl	%eax, %eax
	jne	.L193
	movl	$.LC113, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	argv0, %edx
	movl	stderr, %eax
	movl	%edx, 8(%esp)
	movl	$.LC114, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L193:
	movl	throttles, %ecx
	movl	numthrottles, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	leal	(%ecx,%eax), %ebx
	leal	-5012(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, (%ebx)
	movl	throttles, %ecx
	movl	numthrottles, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	leal	(%ecx,%eax), %edx
	movl	-10040(%ebp), %eax
	movl	%eax, 4(%edx)
	movl	throttles, %ecx
	movl	numthrottles, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	leal	(%ecx,%eax), %edx
	movl	-10036(%ebp), %eax
	movl	%eax, 8(%edx)
	movl	throttles, %ecx
	movl	numthrottles, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	$0, 12(%eax)
	movl	throttles, %ecx
	movl	numthrottles, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	$0, 16(%eax)
	movl	throttles, %ecx
	movl	numthrottles, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	$0, 20(%eax)
	movl	numthrottles, %eax
	addl	$1, %eax
	movl	%eax, numthrottles
.L182:
	movl	-10028(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$5000, 4(%esp)
	leal	-10012(%ebp), %eax
	movl	%eax, (%esp)
	call	fgets
	testl	%eax, %eax
	jne	.L196
	movl	-10028(%ebp), %eax
	movl	%eax, (%esp)
	call	fclose
	movl	-12(%ebp), %eax
	xorl	%gs:20, %eax
	je	.L197
	call	__stack_chk_fail
.L197:
	addl	$10068, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE15:
	.size	read_throttlefile, .-read_throttlefile
	.type	shut_down, @function
shut_down:
.LFB16:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	$0, 4(%esp)
	leal	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	gettimeofday
	leal	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	logstats
	movl	$0, -24(%ebp)
	jmp	.L199
.L202:
	movl	connects, %ecx
	movl	-24(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L200
	movl	connects, %ecx
	movl	-24(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	8(%eax), %eax
	leal	-16(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	httpd_close_conn
.L200:
	movl	connects, %ecx
	movl	-24(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L201
	movl	connects, %ecx
	movl	-24(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	8(%eax), %eax
	movl	%eax, (%esp)
	call	httpd_destroy_conn
	movl	connects, %ecx
	movl	-24(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	8(%eax), %eax
	movl	%eax, (%esp)
	call	free
	movl	httpd_conn_count, %eax
	subl	$1, %eax
	movl	%eax, httpd_conn_count
	movl	connects, %ecx
	movl	-24(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	$0, 8(%eax)
.L201:
	addl	$1, -24(%ebp)
.L199:
	movl	max_connects, %eax
	cmpl	%eax, -24(%ebp)
	jl	.L202
	movl	hs, %eax
	testl	%eax, %eax
	je	.L203
	movl	hs, %eax
	movl	%eax, -20(%ebp)
	movl	$0, hs
	movl	-20(%ebp), %eax
	movl	40(%eax), %eax
	cmpl	$-1, %eax
	je	.L204
	movl	-20(%ebp), %eax
	movl	40(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
.L204:
	movl	-20(%ebp), %eax
	movl	44(%eax), %eax
	cmpl	$-1, %eax
	je	.L205
	movl	-20(%ebp), %eax
	movl	44(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
.L205:
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_terminate
.L203:
	call	mmc_destroy
	call	tmr_destroy
	movl	connects, %eax
	movl	%eax, (%esp)
	call	free
	movl	throttles, %eax
	testl	%eax, %eax
	je	.L198
	movl	throttles, %eax
	movl	%eax, (%esp)
	call	free
.L198:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE16:
	.size	shut_down, .-shut_down
	.section	.rodata
.LC115:
	.string	"too many connections!"
	.align 4
.LC116:
	.string	"the connects free list is messed up"
	.align 4
.LC117:
	.string	"out of memory allocating an httpd_conn"
	.text
	.type	handle_newconnect, @function
handle_newconnect:
.LFB17:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
.L218:
	movl	num_connects, %edx
	movl	max_connects, %eax
	cmpl	%eax, %edx
	jl	.L208
	movl	$.LC115, 4(%esp)
	movl	$4, (%esp)
	call	syslog
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	tmr_run
	movl	$0, %eax
	jmp	.L219
.L208:
	movl	first_free_connect, %eax
	cmpl	$-1, %eax
	je	.L210
	movl	connects, %ecx
	movl	first_free_connect, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L211
.L210:
	movl	$.LC116, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L211:
	movl	connects, %ecx
	movl	first_free_connect, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	.L212
	movl	$456, (%esp)
	call	malloc
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	-12(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	.L213
	movl	$.LC117, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L213:
	movl	-12(%ebp), %eax
	movl	8(%eax), %eax
	movl	$0, (%eax)
	movl	httpd_conn_count, %eax
	addl	$1, %eax
	movl	%eax, httpd_conn_count
.L212:
	movl	-12(%ebp), %eax
	movl	8(%eax), %edx
	movl	hs, %eax
	movl	%edx, 8(%esp)
	movl	12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	httpd_get_conn
	testl	%eax, %eax
	je	.L215
	cmpl	$2, %eax
	je	.L216
	jmp	.L220
.L215:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	tmr_run
	movl	$0, %eax
	jmp	.L219
.L216:
	movl	$1, %eax
	jmp	.L219
.L220:
	movl	-12(%ebp), %eax
	movl	$1, (%eax)
	movl	-12(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, first_free_connect
	movl	-12(%ebp), %eax
	movl	$-1, 4(%eax)
	movl	num_connects, %eax
	addl	$1, %eax
	movl	%eax, num_connects
	movl	-12(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	-12(%ebp), %eax
	movl	%edx, 68(%eax)
	movl	-12(%ebp), %eax
	movl	$0, 72(%eax)
	movl	-12(%ebp), %eax
	movl	$0, 76(%eax)
	movl	-12(%ebp), %eax
	movl	$0, 92(%eax)
	movl	-12(%ebp), %eax
	movl	$0, 52(%eax)
	movl	-12(%ebp), %eax
	movl	8(%eax), %eax
	movl	448(%eax), %eax
	movl	%eax, (%esp)
	call	httpd_set_ndelay
	movl	-12(%ebp), %eax
	movl	8(%eax), %eax
	movl	448(%eax), %eax
	movl	$0, 8(%esp)
	movl	-12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	fdwatch_add_fd
	movl	stats_connections, %eax
	addl	$1, %eax
	movl	%eax, stats_connections
	movl	num_connects, %edx
	movl	stats_simultaneous, %eax
	cmpl	%eax, %edx
	jle	.L217
	movl	num_connects, %eax
	movl	%eax, stats_simultaneous
	jmp	.L218
.L217:
	jmp	.L218
.L219:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE17:
	.size	handle_newconnect, .-handle_newconnect
	.type	handle_read, @function
handle_read:
.LFB18:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	subl	$52, %esp
	.cfi_offset 3, -12
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	144(%eax), %edx
	movl	-16(%ebp), %eax
	movl	140(%eax), %eax
	cmpl	%eax, %edx
	jb	.L222
	movl	-16(%ebp), %eax
	movl	140(%eax), %eax
	cmpl	$5000, %eax
	jbe	.L223
	movl	httpd_err400form, %edx
	movl	httpd_err400title, %eax
	movl	$.LC45, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$.LC45, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$400, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_send_err
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L221
.L223:
	movl	-16(%ebp), %eax
	movl	140(%eax), %eax
	leal	1000(%eax), %ecx
	movl	-16(%ebp), %eax
	leal	140(%eax), %edx
	movl	-16(%ebp), %eax
	addl	$136, %eax
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	httpd_realloc_str
.L222:
	movl	-16(%ebp), %eax
	movl	140(%eax), %edx
	movl	-16(%ebp), %eax
	movl	136(%eax), %ecx
	movl	-16(%ebp), %eax
	movl	144(%eax), %eax
	addl	%eax, %ecx
	movl	-16(%ebp), %eax
	movl	448(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	call	read
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L225
	movl	httpd_err400form, %edx
	movl	httpd_err400title, %eax
	movl	$.LC45, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$.LC45, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$400, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_send_err
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L221
.L225:
	cmpl	$0, -12(%ebp)
	jns	.L226
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L227
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	je	.L227
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	jne	.L228
.L227:
	jmp	.L221
.L228:
	movl	httpd_err400form, %edx
	movl	httpd_err400title, %eax
	movl	$.LC45, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$.LC45, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$400, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_send_err
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L221
.L226:
	movl	-16(%ebp), %eax
	movl	144(%eax), %edx
	movl	-12(%ebp), %eax
	addl	%eax, %edx
	movl	-16(%ebp), %eax
	movl	%edx, 144(%eax)
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 68(%eax)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_got_request
	testl	%eax, %eax
	je	.L244
	cmpl	$2, %eax
	jne	.L243
	movl	httpd_err400form, %edx
	movl	httpd_err400title, %eax
	movl	$.LC45, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$.LC45, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$400, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_send_err
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L221
.L243:
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_parse_request
	testl	%eax, %eax
	jns	.L232
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L221
.L232:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	check_throttles
	testl	%eax, %eax
	jne	.L233
	movl	-16(%ebp), %eax
	movl	172(%eax), %ecx
	movl	httpd_err503form, %edx
	movl	httpd_err503title, %eax
	movl	%ecx, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$.LC45, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$503, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_send_err
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L221
.L233:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_start_request
	testl	%eax, %eax
	jns	.L234
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L221
.L234:
	movl	-16(%ebp), %eax
	movl	336(%eax), %eax
	testl	%eax, %eax
	je	.L235
	movl	-16(%ebp), %eax
	movl	344(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 92(%eax)
	movl	-16(%ebp), %eax
	movl	348(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 88(%eax)
	jmp	.L236
.L235:
	movl	-16(%ebp), %eax
	movl	164(%eax), %eax
	testl	%eax, %eax
	jns	.L237
	movl	8(%ebp), %eax
	movl	$0, 88(%eax)
	jmp	.L236
.L237:
	movl	-16(%ebp), %eax
	movl	164(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 88(%eax)
.L236:
	movl	-16(%ebp), %eax
	movl	452(%eax), %eax
	testl	%eax, %eax
	jne	.L238
	movl	$0, -20(%ebp)
	jmp	.L239
.L240:
	movl	throttles, %ecx
	movl	8(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	12(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%eax, %ecx
	movl	throttles, %ebx
	movl	8(%ebp), %eax
	movl	-20(%ebp), %edx
	movl	12(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	16(%eax), %edx
	movl	-16(%ebp), %eax
	movl	168(%eax), %eax
	addl	%edx, %eax
	movl	%eax, 16(%ecx)
	addl	$1, -20(%ebp)
.L239:
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	cmpl	-20(%ebp), %eax
	jg	.L240
	movl	-16(%ebp), %eax
	movl	168(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 92(%eax)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L221
.L238:
	movl	8(%ebp), %eax
	movl	92(%eax), %edx
	movl	8(%ebp), %eax
	movl	88(%eax), %eax
	cmpl	%eax, %edx
	jl	.L241
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L221
.L241:
	movl	8(%ebp), %eax
	movl	$2, (%eax)
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 64(%eax)
	movl	8(%ebp), %eax
	movl	$0, 80(%eax)
	movl	8(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	-16(%ebp), %eax
	movl	448(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
	movl	-16(%ebp), %eax
	movl	448(%eax), %eax
	movl	$1, 8(%esp)
	movl	8(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	fdwatch_add_fd
	jmp	.L221
.L244:
	nop
.L221:
	addl	$52, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE18:
	.size	handle_read, .-handle_read
	.section	.rodata
	.align 4
.LC118:
	.string	"replacing non-null wakeup_timer!"
	.align 4
.LC119:
	.string	"tmr_create(wakeup_connection) failed"
.LC120:
	.string	"write - %m sending %.80s"
	.text
	.type	handle_send, @function
handle_send:
.LFB19:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%esi
	pushl	%ebx
	subl	$80, %esp
	.cfi_offset 6, -12
	.cfi_offset 3, -16
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, -36(%ebp)
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	cmpl	$-1, %eax
	jne	.L246
	movl	$1000000000, -52(%ebp)
	jmp	.L247
.L246:
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	leal	3(%eax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$2, %eax
	movl	%eax, -52(%ebp)
.L247:
	movl	-36(%ebp), %eax
	movl	304(%eax), %eax
	testl	%eax, %eax
	jne	.L248
	movl	8(%ebp), %eax
	movl	88(%eax), %edx
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, %edx
	movl	-52(%ebp), %eax
	cmpl	%eax, %edx
	cmova	%eax, %edx
	movl	-36(%ebp), %eax
	movl	452(%eax), %ecx
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	addl	%eax, %ecx
	movl	-36(%ebp), %eax
	movl	448(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	call	write
	movl	%eax, -48(%ebp)
	jmp	.L249
.L248:
	movl	-36(%ebp), %eax
	movl	252(%eax), %eax
	movl	%eax, -24(%ebp)
	movl	-36(%ebp), %eax
	movl	304(%eax), %eax
	movl	%eax, -20(%ebp)
	movl	-36(%ebp), %eax
	movl	452(%eax), %edx
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	addl	%edx, %eax
	movl	%eax, -16(%ebp)
	movl	8(%ebp), %eax
	movl	88(%eax), %edx
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, %edx
	movl	-52(%ebp), %eax
	cmpl	%eax, %edx
	cmovbe	%edx, %eax
	movl	%eax, -12(%ebp)
	movl	-36(%ebp), %eax
	movl	448(%eax), %eax
	movl	$2, 8(%esp)
	leal	-24(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	writev
	movl	%eax, -48(%ebp)
.L249:
	cmpl	$0, -48(%ebp)
	jns	.L250
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	jne	.L250
	jmp	.L245
.L250:
	cmpl	$0, -48(%ebp)
	je	.L252
	cmpl	$0, -48(%ebp)
	jns	.L253
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	je	.L252
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	jne	.L253
.L252:
	movl	8(%ebp), %eax
	movl	80(%eax), %eax
	leal	100(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 80(%eax)
	movl	8(%ebp), %eax
	movl	$3, (%eax)
	movl	-36(%ebp), %eax
	movl	448(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
	movl	8(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	8(%ebp), %eax
	movl	72(%eax), %eax
	testl	%eax, %eax
	je	.L254
	movl	$.LC118, 4(%esp)
	movl	$3, (%esp)
	call	syslog
.L254:
	movl	8(%ebp), %eax
	movl	80(%eax), %eax
	movl	$0, 16(%esp)
	movl	%eax, 12(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$wakeup_connection, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	tmr_create
	movl	8(%ebp), %edx
	movl	%eax, 72(%edx)
	movl	8(%ebp), %eax
	movl	72(%eax), %eax
	testl	%eax, %eax
	jne	.L255
	movl	$.LC119, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L255:
	jmp	.L245
.L253:
	cmpl	$0, -48(%ebp)
	jns	.L256
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$32, %eax
	je	.L257
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$22, %eax
	je	.L257
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$104, %eax
	je	.L257
	movl	-36(%ebp), %eax
	movl	172(%eax), %eax
	movl	%eax, 8(%esp)
	movl	$.LC120, 4(%esp)
	movl	$3, (%esp)
	call	syslog
.L257:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	clear_connection
	jmp	.L245
.L256:
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 68(%eax)
	movl	-36(%ebp), %eax
	movl	304(%eax), %eax
	testl	%eax, %eax
	je	.L258
	movl	-48(%ebp), %edx
	movl	-36(%ebp), %eax
	movl	304(%eax), %eax
	cmpl	%eax, %edx
	jae	.L259
	movl	-36(%ebp), %eax
	movl	304(%eax), %edx
	movl	-48(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -32(%ebp)
	movl	-32(%ebp), %edx
	movl	-36(%ebp), %eax
	movl	252(%eax), %ecx
	movl	-48(%ebp), %eax
	addl	%eax, %ecx
	movl	-36(%ebp), %eax
	movl	252(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	call	memmove
	movl	-32(%ebp), %edx
	movl	-36(%ebp), %eax
	movl	%edx, 304(%eax)
	movl	$0, -48(%ebp)
	jmp	.L258
.L259:
	movl	-48(%ebp), %edx
	movl	-36(%ebp), %eax
	movl	304(%eax), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -48(%ebp)
	movl	-36(%ebp), %eax
	movl	$0, 304(%eax)
.L258:
	movl	8(%ebp), %eax
	movl	92(%eax), %edx
	movl	-48(%ebp), %eax
	addl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 92(%eax)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	8(%ebp), %edx
	movl	8(%edx), %edx
	movl	168(%edx), %ecx
	movl	-48(%ebp), %edx
	addl	%ecx, %edx
	movl	%edx, 168(%eax)
	movl	$0, -40(%ebp)
	jmp	.L260
.L261:
	movl	throttles, %ecx
	movl	8(%ebp), %eax
	movl	-40(%ebp), %edx
	movl	12(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%eax, %ecx
	movl	throttles, %ebx
	movl	8(%ebp), %eax
	movl	-40(%ebp), %edx
	movl	12(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	16(%eax), %edx
	movl	-48(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, 16(%ecx)
	addl	$1, -40(%ebp)
.L260:
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	cmpl	-40(%ebp), %eax
	jg	.L261
	movl	8(%ebp), %eax
	movl	92(%eax), %edx
	movl	8(%ebp), %eax
	movl	88(%eax), %eax
	cmpl	%eax, %edx
	jl	.L262
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L245
.L262:
	movl	8(%ebp), %eax
	movl	80(%eax), %eax
	cmpl	$100, %eax
	jle	.L263
	movl	8(%ebp), %eax
	movl	80(%eax), %eax
	leal	-100(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 80(%eax)
.L263:
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	cmpl	$-1, %eax
	je	.L245
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	64(%eax), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -44(%ebp)
	cmpl	$0, -44(%ebp)
	jne	.L265
	movl	$1, -44(%ebp)
.L265:
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	168(%eax), %eax
	cltd
	idivl	-44(%ebp)
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	cmpl	%eax, %edx
	jle	.L245
	movl	8(%ebp), %eax
	movl	$3, (%eax)
	movl	-36(%ebp), %eax
	movl	448(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	168(%eax), %eax
	movl	8(%ebp), %edx
	movl	56(%edx), %esi
	cltd
	idivl	%esi
	subl	-44(%ebp), %eax
	movl	%eax, -28(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	8(%ebp), %eax
	movl	72(%eax), %eax
	testl	%eax, %eax
	je	.L266
	movl	$.LC118, 4(%esp)
	movl	$3, (%esp)
	call	syslog
.L266:
	cmpl	$0, -28(%ebp)
	jle	.L267
	movl	-28(%ebp), %eax
	imull	$1000, %eax, %eax
	jmp	.L268
.L267:
	movl	$500, %eax
.L268:
	movl	$0, 16(%esp)
	movl	%eax, 12(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$wakeup_connection, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	tmr_create
	movl	8(%ebp), %edx
	movl	%eax, 72(%edx)
	movl	8(%ebp), %eax
	movl	72(%eax), %eax
	testl	%eax, %eax
	jne	.L245
	movl	$.LC119, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L245:
	addl	$80, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE19:
	.size	handle_send, .-handle_send
	.type	handle_linger, @function
handle_linger:
.LFB20:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$4152, %esp
	movl	8(%ebp), %eax
	movl	%eax, -4124(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -4128(%ebp)
	movl	%gs:20, %eax
	movl	%eax, -12(%ebp)
	xorl	%eax, %eax
	movl	-4124(%ebp), %eax
	movl	8(%eax), %eax
	movl	448(%eax), %eax
	movl	$4096, 8(%esp)
	leal	-4108(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	read
	movl	%eax, -4112(%ebp)
	cmpl	$0, -4112(%ebp)
	jns	.L271
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L270
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	je	.L270
.L271:
	cmpl	$0, -4112(%ebp)
	jg	.L270
	movl	-4128(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-4124(%ebp), %eax
	movl	%eax, (%esp)
	call	really_clear_connection
.L270:
	movl	-12(%ebp), %eax
	xorl	%gs:20, %eax
	je	.L275
	call	__stack_chk_fail
.L275:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE20:
	.size	handle_linger, .-handle_linger
	.section	.rodata
	.align 4
.LC121:
	.string	"throttle sending count was negative - shouldn't happen!"
	.text
	.type	check_throttles, @function
check_throttles:
.LFB21:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%esi
	pushl	%ebx
	subl	$32, %esp
	.cfi_offset 6, -12
	.cfi_offset 3, -16
	movl	8(%ebp), %eax
	movl	$0, 52(%eax)
	movl	8(%ebp), %eax
	movl	$-1, 60(%eax)
	movl	8(%ebp), %eax
	movl	60(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 56(%eax)
	movl	$0, -16(%ebp)
	jmp	.L277
.L287:
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	188(%eax), %ecx
	movl	throttles, %ebx
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	(%eax), %eax
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	call	match
	testl	%eax, %eax
	je	.L278
	movl	throttles, %ecx
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %ebx
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	4(%eax), %eax
	addl	%eax, %eax
	cmpl	%eax, %ecx
	jle	.L279
	movl	$0, %eax
	jmp	.L280
.L279:
	movl	throttles, %ecx
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %ebx
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	8(%eax), %eax
	cmpl	%eax, %ecx
	jge	.L281
	movl	$0, %eax
	jmp	.L280
.L281:
	movl	throttles, %ecx
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %eax
	testl	%eax, %eax
	jns	.L282
	movl	$.LC121, 4(%esp)
	movl	$3, (%esp)
	call	syslog
	movl	throttles, %ecx
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	$0, 20(%eax)
.L282:
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	leal	1(%eax), %ecx
	movl	8(%ebp), %edx
	movl	%ecx, 52(%edx)
	movl	8(%ebp), %edx
	movl	-16(%ebp), %ecx
	movl	%ecx, 12(%edx,%eax,4)
	movl	throttles, %ecx
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %edx
	addl	$1, %edx
	movl	%edx, 20(%eax)
	movl	throttles, %ecx
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	4(%eax), %ecx
	movl	throttles, %ebx
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	20(%eax), %esi
	movl	%ecx, %eax
	cltd
	idivl	%esi
	movl	%eax, -12(%ebp)
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	cmpl	$-1, %eax
	jne	.L283
	movl	8(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 56(%eax)
	jmp	.L284
.L283:
	movl	8(%ebp), %eax
	movl	56(%eax), %edx
	movl	-12(%ebp), %eax
	cmpl	%eax, %edx
	cmovg	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 56(%eax)
.L284:
	movl	throttles, %ecx
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	8(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	8(%ebp), %eax
	movl	60(%eax), %eax
	cmpl	$-1, %eax
	jne	.L285
	movl	8(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	%edx, 60(%eax)
	jmp	.L278
.L285:
	movl	8(%ebp), %eax
	movl	60(%eax), %edx
	movl	-12(%ebp), %eax
	cmpl	%eax, %edx
	cmovl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 60(%eax)
.L278:
	addl	$1, -16(%ebp)
.L277:
	movl	numthrottles, %eax
	cmpl	%eax, -16(%ebp)
	jge	.L286
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	cmpl	$9, %eax
	jle	.L287
.L286:
	movl	$1, %eax
.L280:
	addl	$32, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE21:
	.size	check_throttles, .-check_throttles
	.type	clear_throttles, @function
clear_throttles:
.LFB22:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$16, %esp
	movl	$0, -4(%ebp)
	jmp	.L289
.L290:
	movl	throttles, %ecx
	movl	8(%ebp), %eax
	movl	-4(%ebp), %edx
	movl	12(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %edx
	subl	$1, %edx
	movl	%edx, 20(%eax)
	addl	$1, -4(%ebp)
.L289:
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	cmpl	-4(%ebp), %eax
	jg	.L290
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE22:
	.size	clear_throttles, .-clear_throttles
	.section	.rodata
	.align 4
.LC122:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.align 4
.LC123:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.align 4
.LC124:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.text
	.type	update_throttles, @function
update_throttles:
.LFB23:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$76, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movl	$0, -44(%ebp)
	jmp	.L292
.L296:
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	leal	(%ecx,%eax), %ebx
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %eax
	leal	(%eax,%eax), %esi
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	16(%eax), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	leal	(%esi,%eax), %ecx
	movl	$1431655766, %edx
	movl	%ecx, %eax
	imull	%edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, 12(%ebx)
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	$0, 16(%eax)
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %ebx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	4(%eax), %eax
	cmpl	%eax, %ecx
	jle	.L293
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %eax
	testl	%eax, %eax
	je	.L293
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %ebx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	4(%eax), %eax
	addl	%eax, %eax
	cmpl	%eax, %ecx
	jle	.L294
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %esi
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	4(%eax), %ebx
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %edi
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%edi, %eax
	movl	(%eax), %eax
	movl	%esi, 24(%esp)
	movl	%ebx, 20(%esp)
	movl	%ecx, 16(%esp)
	movl	%eax, 12(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC122, 4(%esp)
	movl	$5, (%esp)
	call	syslog
	jmp	.L293
.L294:
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %esi
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	4(%eax), %ebx
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %edi
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%edi, %eax
	movl	(%eax), %eax
	movl	%esi, 24(%esp)
	movl	%ebx, 20(%esp)
	movl	%ecx, 16(%esp)
	movl	%eax, 12(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC123, 4(%esp)
	movl	$6, (%esp)
	call	syslog
.L293:
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %ebx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	8(%eax), %eax
	cmpl	%eax, %ecx
	jge	.L295
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %eax
	testl	%eax, %eax
	je	.L295
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %esi
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	8(%eax), %ebx
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %edi
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%edi, %eax
	movl	(%eax), %eax
	movl	%esi, 24(%esp)
	movl	%ebx, 20(%esp)
	movl	%ecx, 16(%esp)
	movl	%eax, 12(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC124, 4(%esp)
	movl	$5, (%esp)
	call	syslog
.L295:
	addl	$1, -44(%ebp)
.L292:
	movl	numthrottles, %eax
	cmpl	%eax, -44(%ebp)
	jl	.L296
	movl	$0, -36(%ebp)
	jmp	.L297
.L304:
	movl	connects, %ecx
	movl	-36(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	%eax, -32(%ebp)
	movl	-32(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$2, %eax
	je	.L298
	movl	-32(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$3, %eax
	jne	.L299
.L298:
	movl	-32(%ebp), %eax
	movl	$-1, 56(%eax)
	movl	$0, -40(%ebp)
	jmp	.L300
.L303:
	movl	-32(%ebp), %eax
	movl	-40(%ebp), %edx
	movl	12(%eax,%edx,4), %eax
	movl	%eax, -44(%ebp)
	movl	throttles, %ecx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	4(%eax), %ecx
	movl	throttles, %ebx
	movl	-44(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	20(%eax), %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, -28(%ebp)
	movl	-32(%ebp), %eax
	movl	56(%eax), %eax
	cmpl	$-1, %eax
	jne	.L301
	movl	-32(%ebp), %eax
	movl	-28(%ebp), %edx
	movl	%edx, 56(%eax)
	jmp	.L302
.L301:
	movl	-32(%ebp), %eax
	movl	56(%eax), %edx
	movl	-28(%ebp), %eax
	cmpl	%eax, %edx
	cmovg	%eax, %edx
	movl	-32(%ebp), %eax
	movl	%edx, 56(%eax)
.L302:
	addl	$1, -40(%ebp)
.L300:
	movl	-32(%ebp), %eax
	movl	52(%eax), %eax
	cmpl	-40(%ebp), %eax
	jg	.L303
.L299:
	addl	$1, -36(%ebp)
.L297:
	movl	max_connects, %eax
	cmpl	%eax, -36(%ebp)
	jl	.L304
	addl	$76, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE23:
	.size	update_throttles, .-update_throttles
	.type	finish_connection, @function
finish_connection:
.LFB24:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, (%esp)
	call	httpd_write_response
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	clear_connection
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE24:
	.size	finish_connection, .-finish_connection
	.section	.rodata
	.align 4
.LC125:
	.string	"replacing non-null linger_timer!"
	.align 4
.LC126:
	.string	"tmr_create(linger_clear_connection) failed"
	.text
	.type	clear_connection, @function
clear_connection:
.LFB25:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	movl	8(%ebp), %eax
	movl	72(%eax), %eax
	testl	%eax, %eax
	je	.L307
	movl	8(%ebp), %eax
	movl	72(%eax), %eax
	movl	%eax, (%esp)
	call	tmr_cancel
	movl	8(%ebp), %eax
	movl	$0, 72(%eax)
.L307:
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$4, %eax
	jne	.L308
	movl	8(%ebp), %eax
	movl	76(%eax), %eax
	movl	%eax, (%esp)
	call	tmr_cancel
	movl	8(%ebp), %eax
	movl	$0, 76(%eax)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	$0, 356(%eax)
.L308:
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	356(%eax), %eax
	testl	%eax, %eax
	je	.L309
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$3, %eax
	je	.L310
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	448(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
.L310:
	movl	8(%ebp), %eax
	movl	$4, (%eax)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	448(%eax), %eax
	movl	$1, 4(%esp)
	movl	%eax, (%esp)
	call	shutdown
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	448(%eax), %eax
	movl	$0, 8(%esp)
	movl	8(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	fdwatch_add_fd
	movl	8(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	8(%ebp), %eax
	movl	76(%eax), %eax
	testl	%eax, %eax
	je	.L311
	movl	$.LC125, 4(%esp)
	movl	$3, (%esp)
	call	syslog
.L311:
	movl	$0, 16(%esp)
	movl	$500, 12(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$linger_clear_connection, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	tmr_create
	movl	8(%ebp), %edx
	movl	%eax, 76(%edx)
	movl	8(%ebp), %eax
	movl	76(%eax), %eax
	testl	%eax, %eax
	jne	.L306
	movl	$.LC126, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L309:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	really_clear_connection
.L306:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE25:
	.size	clear_connection, .-clear_connection
	.type	really_clear_connection, @function
really_clear_connection:
.LFB26:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	168(%eax), %edx
	movl	stats_bytes, %eax
	addl	%edx, %eax
	movl	%eax, stats_bytes
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$3, %eax
	je	.L314
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	448(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
.L314:
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	httpd_close_conn
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	clear_throttles
	movl	8(%ebp), %eax
	movl	76(%eax), %eax
	testl	%eax, %eax
	je	.L315
	movl	8(%ebp), %eax
	movl	76(%eax), %eax
	movl	%eax, (%esp)
	call	tmr_cancel
	movl	8(%ebp), %eax
	movl	$0, 76(%eax)
.L315:
	movl	8(%ebp), %eax
	movl	$0, (%eax)
	movl	first_free_connect, %edx
	movl	8(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	8(%ebp), %edx
	movl	connects, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	sarl	$5, %eax
	imull	$-1431655765, %eax, %eax
	movl	%eax, first_free_connect
	movl	num_connects, %eax
	subl	$1, %eax
	movl	%eax, num_connects
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE26:
	.size	really_clear_connection, .-really_clear_connection
	.section	.rodata
	.align 4
.LC127:
	.string	"%.80s connection timed out reading"
	.align 4
.LC128:
	.string	"%.80s connection timed out sending"
	.text
	.type	idle, @function
idle:
.LFB27:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	movl	$0, -16(%ebp)
	jmp	.L317
.L323:
	movl	connects, %ecx
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$1, %eax
	je	.L319
	cmpl	$1, %eax
	jl	.L318
	cmpl	$3, %eax
	jg	.L318
	jmp	.L324
.L319:
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	-12(%ebp), %eax
	movl	68(%eax), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	cmpl	$59, %eax
	jle	.L321
	movl	-12(%ebp), %eax
	movl	8(%eax), %eax
	addl	$8, %eax
	movl	%eax, (%esp)
	call	httpd_ntoa
	movl	%eax, 8(%esp)
	movl	$.LC127, 4(%esp)
	movl	$6, (%esp)
	call	syslog
	movl	httpd_err408form, %ecx
	movl	httpd_err408title, %edx
	movl	-12(%ebp), %eax
	movl	8(%eax), %eax
	movl	$.LC45, 20(%esp)
	movl	%ecx, 16(%esp)
	movl	$.LC45, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$408, 4(%esp)
	movl	%eax, (%esp)
	call	httpd_send_err
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L318
.L321:
	jmp	.L318
.L324:
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	-12(%ebp), %eax
	movl	68(%eax), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	cmpl	$299, %eax
	jle	.L322
	movl	-12(%ebp), %eax
	movl	8(%eax), %eax
	addl	$8, %eax
	movl	%eax, (%esp)
	call	httpd_ntoa
	movl	%eax, 8(%esp)
	movl	$.LC128, 4(%esp)
	movl	$6, (%esp)
	call	syslog
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	clear_connection
	jmp	.L325
.L322:
.L325:
	nop
.L318:
	addl	$1, -16(%ebp)
.L317:
	movl	max_connects, %eax
	cmpl	%eax, -16(%ebp)
	jl	.L323
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE27:
	.size	idle, .-idle
	.type	wakeup_connection, @function
wakeup_connection:
.LFB28:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	$0, 72(%eax)
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$3, %eax
	jne	.L326
	movl	-12(%ebp), %eax
	movl	$2, (%eax)
	movl	-12(%ebp), %eax
	movl	8(%eax), %eax
	movl	448(%eax), %eax
	movl	$1, 8(%esp)
	movl	-12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	fdwatch_add_fd
.L326:
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE28:
	.size	wakeup_connection, .-wakeup_connection
	.type	linger_clear_connection, @function
linger_clear_connection:
.LFB29:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	$0, 76(%eax)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	really_clear_connection
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE29:
	.size	linger_clear_connection, .-linger_clear_connection
	.type	occasional, @function
occasional:
.LFB30:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	mmc_cleanup
	call	tmr_cleanup
	movl	$1, watchdog_flag
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE30:
	.size	occasional, .-occasional
	.type	show_stats, @function
show_stats:
.LFB31:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	logstats
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE31:
	.size	show_stats, .-show_stats
	.section	.rodata
	.align 4
.LC129:
	.string	"up %ld seconds, stats for %ld seconds:"
	.text
	.type	logstats, @function
logstats:
.LFB32:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$56, %esp
	cmpl	$0, 8(%ebp)
	jne	.L332
	movl	$0, 4(%esp)
	leal	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	gettimeofday
	leal	-16(%ebp), %eax
	movl	%eax, 8(%ebp)
.L332:
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -24(%ebp)
	movl	start_time, %eax
	movl	-24(%ebp), %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -20(%ebp)
	movl	stats_time, %eax
	movl	-24(%ebp), %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -28(%ebp)
	cmpl	$0, -28(%ebp)
	jne	.L333
	movl	$1, -28(%ebp)
.L333:
	movl	-24(%ebp), %eax
	movl	%eax, stats_time
	movl	-28(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC129, 4(%esp)
	movl	$6, (%esp)
	call	syslog
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	thttpd_logstats
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_logstats
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	mmc_logstats
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	fdwatch_logstats
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	tmr_logstats
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE32:
	.size	logstats, .-logstats
	.section	.rodata
	.align 4
.LC130:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
	.text
	.type	thttpd_logstats, @function
thttpd_logstats:
.LFB33:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%esi
	pushl	%ebx
	subl	$48, %esp
	.cfi_offset 6, -12
	.cfi_offset 3, -16
	cmpl	$0, 8(%ebp)
	jle	.L335
	movl	httpd_conn_count, %esi
	movl	stats_bytes, %eax
	movl	%eax, -12(%ebp)
	fildl	-12(%ebp)
	fildl	8(%ebp)
	fdivrp	%st, %st(1)
	movl	stats_bytes, %eax
	cltd
	movl	stats_simultaneous, %ebx
	movl	stats_connections, %ecx
	movl	%ecx, -12(%ebp)
	fildl	-12(%ebp)
	fildl	8(%ebp)
	fdivrp	%st, %st(1)
	fxch	%st(1)
	movl	stats_connections, %ecx
	movl	%esi, 40(%esp)
	fstpl	32(%esp)
	movl	%eax, 24(%esp)
	movl	%edx, 28(%esp)
	movl	%ebx, 20(%esp)
	fstpl	12(%esp)
	movl	%ecx, 8(%esp)
	movl	$.LC130, 4(%esp)
	movl	$6, (%esp)
	call	syslog
.L335:
	movl	$0, stats_connections
	movl	$0, stats_bytes
	movl	$0, stats_simultaneous
	addl	$48, %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE33:
	.size	thttpd_logstats, .-thttpd_logstats
	.ident	"GCC: (GNU) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
