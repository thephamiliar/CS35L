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
	movl	%eax, -12(%ebp)
.L10:
	movl	$1, 8(%esp)
	leal	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$-1, (%esp)
	call	waitpid
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	jne	.L3
	jmp	.L4
.L3:
	cmpl	$0, -16(%ebp)
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
	movl	-12(%ebp), %edx
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
	movl	$32767, 4536(%esp)
	movl	$32767, 4532(%esp)
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, argv0
	movl	argv0, %eax
	movl	$47, 4(%esp)
	movl	%eax, (%esp)
	call	strrchr
	movl	%eax, 4540(%esp)
	cmpl	$0, 4540(%esp)
	je	.L23
	addl	$1, 4540(%esp)
	jmp	.L24
.L23:
	movl	argv0, %eax
	movl	%eax, 4540(%esp)
.L24:
	movl	$24, 8(%esp)
	movl	$9, 4(%esp)
	movl	4540(%esp), %eax
	movl	%eax, (%esp)
	call	openlog
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_args
	call	tzset
	leal	140(%esp), %eax
	movl	%eax, 20(%esp)
	movl	$128, 16(%esp)
	leal	148(%esp), %eax
	movl	%eax, 12(%esp)
	leal	144(%esp), %eax
	movl	%eax, 8(%esp)
	movl	$128, 4(%esp)
	leal	276(%esp), %eax
	movl	%eax, (%esp)
	call	lookup_hostname
	movl	144(%esp), %eax
	testl	%eax, %eax
	jne	.L25
	movl	140(%esp), %eax
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
	movl	%eax, 4520(%esp)
	cmpl	$0, 4520(%esp)
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
	movl	4520(%esp), %eax
	movl	8(%eax), %eax
	movl	%eax, 4536(%esp)
	movl	4520(%esp), %eax
	movl	12(%eax), %eax
	movl	%eax, 4532(%esp)
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
	movl	$0, 4528(%esp)
	jmp	.L35
.L30:
	movl	logfile, %eax
	movl	$.LC4, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L32
	movl	stdout, %eax
	movl	%eax, 4528(%esp)
	jmp	.L35
.L32:
	movl	logfile, %eax
	movl	$.LC6, 4(%esp)
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, 4528(%esp)
	cmpl	$0, 4528(%esp)
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
	movl	4528(%esp), %eax
	movl	%eax, (%esp)
	call	fileno
	movl	$1, 8(%esp)
	movl	$2, 4(%esp)
	movl	%eax, (%esp)
	call	fcntl
	call	getuid
	testl	%eax, %eax
	jne	.L35
	movl	4528(%esp), %eax
	movl	%eax, (%esp)
	call	fileno
	movl	4532(%esp), %edx
	movl	%edx, 8(%esp)
	movl	4536(%esp), %edx
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
	movl	$0, 4528(%esp)
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
	leal	407(%esp), %eax
	movl	%eax, (%esp)
	call	getcwd
	leal	407(%esp), %eax
	movl	%eax, (%esp)
	call	strlen
	subl	$1, %eax
	movzbl	407(%esp,%eax), %eax
	cmpb	$47, %al
	je	.L37
	leal	407(%esp), %eax
	movl	$-1, %ecx
	movl	%eax, %edx
	movl	$0, %eax
	movl	%edx, %edi
	repnz; scasb
	movl	%ecx, %eax
	notl	%eax
	leal	-1(%eax), %edx
	leal	407(%esp), %eax
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
	cmpl	%eax, 4528(%esp)
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
	movl	%eax, 4516(%esp)
	cmpl	$0, 4516(%esp)
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
	movl	4516(%esp), %eax
	movl	%eax, (%esp)
	call	fprintf
	movl	4516(%esp), %eax
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
	leal	407(%esp), %eax
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
	leal	407(%esp), %eax
	movl	%eax, (%esp)
	call	strlen
	movl	logfile, %edx
	movl	%eax, 8(%esp)
	leal	407(%esp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	strncmp
	testl	%eax, %eax
	jne	.L47
	movl	logfile, %ebx
	leal	407(%esp), %eax
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
	leal	407(%esp), %eax
	movw	$47, (%eax)
	leal	407(%esp), %eax
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
	movl	%eax, 124(%esp)
	movl	do_global_passwd, %eax
	movl	%eax, 120(%esp)
	movl	do_vhost, %eax
	movl	%eax, 116(%esp)
	movl	no_symlink_check, %eax
	movl	%eax, 112(%esp)
	movl	no_log, %eax
	movl	%eax, 108(%esp)
	movl	max_age, %eax
	movl	%eax, 104(%esp)
	movl	p3p, %eax
	movl	%eax, 100(%esp)
	movl	charset, %eax
	movl	%eax, 96(%esp)
	movl	cgi_limit, %eax
	movl	%eax, 92(%esp)
	movl	cgi_pattern, %eax
	movl	%eax, 88(%esp)
	movzwl	port, %eax
	movzwl	%ax, %eax
	movl	%eax, 84(%esp)
	movl	140(%esp), %eax
	testl	%eax, %eax
	je	.L49
	leal	148(%esp), %ebx
	jmp	.L50
.L49:
	movl	$0, %ebx
.L50:
	movl	144(%esp), %eax
	testl	%eax, %eax
	je	.L51
	leal	276(%esp), %edx
	jmp	.L52
.L51:
	movl	$0, %edx
.L52:
	movl	hostname, %ecx
	movl	%esi, 68(%esp)
	movl	%edi, 64(%esp)
	movl	124(%esp), %eax
	movl	%eax, 60(%esp)
	movl	120(%esp), %eax
	movl	%eax, 56(%esp)
	movl	116(%esp), %eax
	movl	%eax, 52(%esp)
	movl	112(%esp), %eax
	movl	%eax, 48(%esp)
	movl	4528(%esp), %eax
	movl	%eax, 44(%esp)
	movl	108(%esp), %eax
	movl	%eax, 40(%esp)
	leal	407(%esp), %eax
	movl	%eax, 36(%esp)
	movl	104(%esp), %eax
	movl	%eax, 32(%esp)
	movl	100(%esp), %eax
	movl	%eax, 28(%esp)
	movl	96(%esp), %eax
	movl	%eax, 24(%esp)
	movl	92(%esp), %eax
	movl	%eax, 20(%esp)
	movl	88(%esp), %eax
	movl	%eax, 16(%esp)
	movl	84(%esp), %eax
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
	movl	4532(%esp), %eax
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
	movl	4532(%esp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	initgroups
	testl	%eax, %eax
	jns	.L61
	movl	$.LC38, 4(%esp)
	movl	$4, (%esp)
	call	syslog
.L61:
	movl	4536(%esp), %eax
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
	movl	$0, 4524(%esp)
	jmp	.L64
.L65:
	movl	connects, %ecx
	movl	4524(%esp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	$0, (%eax)
	movl	connects, %ecx
	movl	4524(%esp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	4524(%esp), %edx
	addl	$1, %edx
	movl	%edx, 4(%eax)
	movl	connects, %ecx
	movl	4524(%esp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	$0, 8(%eax)
	addl	$1, 4524(%esp)
.L64:
	movl	max_connects, %eax
	cmpl	%eax, 4524(%esp)
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
	leal	132(%esp), %eax
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
	leal	132(%esp), %eax
	movl	%eax, (%esp)
	call	tmr_mstimeout
	movl	%eax, (%esp)
	call	fdwatch
	movl	%eax, 4512(%esp)
	cmpl	$0, 4512(%esp)
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
	leal	132(%esp), %eax
	movl	%eax, (%esp)
	call	tmr_prepare_timeval
	cmpl	$0, 4512(%esp)
	jne	.L73
	leal	132(%esp), %eax
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
	leal	132(%esp), %eax
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
	leal	132(%esp), %eax
	movl	%eax, (%esp)
	call	handle_newconnect
	testl	%eax, %eax
	je	.L75
	jmp	.L68
.L75:
	jmp	.L76
.L82:
	cmpl	$0, 4508(%esp)
	jne	.L77
	jmp	.L76
.L77:
	movl	4508(%esp), %eax
	movl	8(%eax), %eax
	movl	%eax, 4504(%esp)
	movl	4504(%esp), %eax
	movl	448(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L78
	leal	132(%esp), %eax
	movl	%eax, 4(%esp)
	movl	4508(%esp), %eax
	movl	%eax, (%esp)
	call	clear_connection
	jmp	.L76
.L78:
	movl	4508(%esp), %eax
	movl	(%eax), %eax
	cmpl	$2, %eax
	je	.L79
	cmpl	$4, %eax
	je	.L80
	cmpl	$1, %eax
	jne	.L76
	leal	132(%esp), %eax
	movl	%eax, 4(%esp)
	movl	4508(%esp), %eax
	movl	%eax, (%esp)
	call	handle_read
	jmp	.L76
.L79:
	leal	132(%esp), %eax
	movl	%eax, 4(%esp)
	movl	4508(%esp), %eax
	movl	%eax, (%esp)
	call	handle_send
	jmp	.L76
.L80:
	leal	132(%esp), %eax
	movl	%eax, 4(%esp)
	movl	4508(%esp), %eax
	movl	%eax, (%esp)
	call	handle_linger
	nop
.L76:
	call	fdwatch_get_next_client_data
	movl	%eax, 4508(%esp)
	cmpl	$-1, 4508(%esp)
	jne	.L82
	leal	132(%esp), %eax
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
	jmp	.L87
.L113:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC46, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L88
	movl	$.LC47, (%esp)
	call	puts
	movl	$0, (%esp)
	call	exit
.L88:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC48, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L89
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L89
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	read_config
	jmp	.L90
.L89:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC49, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L91
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L91
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	atoi
	movw	%ax, port
	jmp	.L90
.L91:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC50, 4(%esp)
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
	movl	%eax, dir
	jmp	.L90
.L92:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC51, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L93
	movl	$1, do_chroot
	movl	$1, no_symlink_check
	jmp	.L90
.L93:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC52, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L94
	movl	$0, do_chroot
	movl	$0, no_symlink_check
	jmp	.L90
.L94:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC53, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L95
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L95
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, data_dir
	jmp	.L90
.L95:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC54, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L96
	movl	$0, no_symlink_check
	jmp	.L90
.L96:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC55, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L97
	movl	$1, no_symlink_check
	jmp	.L90
.L97:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC56, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L98
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L98
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, user
	jmp	.L90
.L98:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC57, 4(%esp)
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
	movl	%eax, cgi_pattern
	jmp	.L90
.L99:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC58, 4(%esp)
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
	movl	%eax, throttlefile
	jmp	.L90
.L100:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC59, 4(%esp)
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
	movl	%eax, hostname
	jmp	.L90
.L101:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC60, 4(%esp)
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
	movl	%eax, logfile
	jmp	.L90
.L102:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC61, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L103
	movl	$1, do_vhost
	jmp	.L90
.L103:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC62, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L104
	movl	$0, do_vhost
	jmp	.L90
.L104:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC63, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L105
	movl	$1, do_global_passwd
	jmp	.L90
.L105:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC64, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L106
	movl	$0, do_global_passwd
	jmp	.L90
.L106:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC65, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L107
	movl	-12(%ebp), %eax
	addl	$1, %eax
	cmpl	8(%ebp), %eax
	jge	.L107
	addl	$1, -12(%ebp)
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	%eax, pidfile
	jmp	.L90
.L107:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC66, 4(%esp)
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
	movl	%eax, charset
	jmp	.L90
.L108:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC67, 4(%esp)
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
	movl	%eax, p3p
	jmp	.L90
.L109:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC68, 4(%esp)
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
	movl	%eax, (%esp)
	call	atoi
	movl	%eax, max_age
	jmp	.L90
.L110:
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movl	$.LC69, 4(%esp)
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L111
	movl	$1, debug
	jmp	.L90
.L111:
	call	usage
.L90:
	addl	$1, -12(%ebp)
.L87:
	movl	-12(%ebp), %eax
	cmpl	8(%ebp), %eax
	jge	.L112
	movl	-12(%ebp), %eax
	leal	0(,%eax,4), %edx
	movl	12(%ebp), %eax
	addl	%edx, %eax
	movl	(%eax), %eax
	movzbl	(%eax), %eax
	cmpb	$45, %al
	je	.L113
.L112:
	movl	-12(%ebp), %eax
	cmpl	8(%ebp), %eax
	je	.L86
	call	usage
.L86:
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
	subl	$10056, %esp
	movl	$.LC71, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, -24(%ebp)
	cmpl	$0, -24(%ebp)
	jne	.L117
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L117:
	jmp	.L118
.L153:
	movl	$35, 4(%esp)
	leal	-10028(%ebp), %eax
	movl	%eax, (%esp)
	call	strchr
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	je	.L119
	movl	-12(%ebp), %eax
	movb	$0, (%eax)
.L119:
	leal	-10028(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	$.LC72, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	strspn
	addl	%eax, -12(%ebp)
	jmp	.L120
.L152:
	movl	$.LC72, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	strcspn
	movl	-12(%ebp), %edx
	addl	%edx, %eax
	movl	%eax, -16(%ebp)
	jmp	.L121
.L122:
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -16(%ebp)
	movb	$0, (%eax)
.L121:
	movl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$32, %al
	je	.L122
	movl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$9, %al
	je	.L122
	movl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$10, %al
	je	.L122
	movl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$13, %al
	je	.L122
	movl	-12(%ebp), %eax
	movl	%eax, -28(%ebp)
	movl	$61, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strchr
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	je	.L123
	movl	-20(%ebp), %eax
	leal	1(%eax), %edx
	movl	%edx, -20(%ebp)
	movb	$0, (%eax)
.L123:
	movl	$.LC73, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L124
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, debug
	jmp	.L125
.L124:
	movl	$.LC74, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L126
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	atoi
	movw	%ax, port
	jmp	.L125
.L126:
	movl	$.LC75, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L127
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, dir
	jmp	.L125
.L127:
	movl	$.LC25, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L128
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, do_chroot
	movl	$1, no_symlink_check
	jmp	.L125
.L128:
	movl	$.LC76, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L129
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$0, do_chroot
	movl	$0, no_symlink_check
	jmp	.L125
.L129:
	movl	$.LC77, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L130
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, data_dir
	jmp	.L125
.L130:
	movl	$.LC78, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L131
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$0, no_symlink_check
	jmp	.L125
.L131:
	movl	$.LC79, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L132
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, no_symlink_check
	jmp	.L125
.L132:
	movl	$.LC80, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L133
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$0, no_symlink_check
	jmp	.L125
.L133:
	movl	$.LC81, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L134
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, no_symlink_check
	jmp	.L125
.L134:
	movl	$.LC82, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L135
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, user
	jmp	.L125
.L135:
	movl	$.LC83, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L136
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, cgi_pattern
	jmp	.L125
.L136:
	movl	$.LC84, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L137
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	atoi
	movl	%eax, cgi_limit
	jmp	.L125
.L137:
	movl	$.LC85, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L138
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, url_pattern
	jmp	.L125
.L138:
	movl	$.LC86, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L139
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, no_empty_referers
	jmp	.L125
.L139:
	movl	$.LC87, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L140
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, local_pattern
	jmp	.L125
.L140:
	movl	$.LC88, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L141
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, throttlefile
	jmp	.L125
.L141:
	movl	$.LC89, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L142
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, hostname
	jmp	.L125
.L142:
	movl	$.LC90, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L143
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, logfile
	jmp	.L125
.L143:
	movl	$.LC91, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L144
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, do_vhost
	jmp	.L125
.L144:
	movl	$.LC92, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L145
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$0, do_vhost
	jmp	.L125
.L145:
	movl	$.LC93, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L146
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$1, do_global_passwd
	jmp	.L125
.L146:
	movl	$.LC94, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L147
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	no_value_required
	movl	$0, do_global_passwd
	jmp	.L125
.L147:
	movl	$.LC95, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L148
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, pidfile
	jmp	.L125
.L148:
	movl	$.LC96, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L149
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, charset
	jmp	.L125
.L149:
	movl	$.LC97, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L150
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	e_strdup
	movl	%eax, p3p
	jmp	.L125
.L150:
	movl	$.LC98, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	strcasecmp
	testl	%eax, %eax
	jne	.L151
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	value_required
	movl	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	atoi
	movl	%eax, max_age
	jmp	.L125
.L151:
	movl	argv0, %edx
	movl	stderr, %eax
	movl	-28(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC99, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	movl	$1, (%esp)
	call	exit
.L125:
	movl	-16(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	$.LC72, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	strspn
	addl	%eax, -12(%ebp)
.L120:
	movl	-12(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L152
.L118:
	movl	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$10000, 4(%esp)
	leal	-10028(%ebp), %eax
	movl	%eax, (%esp)
	call	fgets
	testl	%eax, %eax
	jne	.L153
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	fclose
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
	jne	.L154
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
.L154:
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
	je	.L156
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
.L156:
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
	jne	.L159
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
.L159:
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
	subl	$100, %esp
	.cfi_offset 3, -12
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
	leal	-66(%ebp), %eax
	movl	%eax, (%esp)
	call	snprintf
	movl	hostname, %eax
	leal	-72(%ebp), %edx
	movl	%edx, 12(%esp)
	leal	-56(%ebp), %edx
	movl	%edx, 8(%esp)
	leal	-66(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	getaddrinfo
	movl	%eax, -24(%ebp)
	cmpl	$0, -24(%ebp)
	je	.L162
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	gai_strerror
	movl	hostname, %edx
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC105, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	-24(%ebp), %eax
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
.L162:
	movl	$0, -16(%ebp)
	movl	$0, -20(%ebp)
	movl	-72(%ebp), %eax
	movl	%eax, -12(%ebp)
	jmp	.L163
.L169:
	movl	-12(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	$2, %eax
	je	.L165
	cmpl	$10, %eax
	jne	.L164
	cmpl	$0, -16(%ebp)
	jne	.L167
	movl	-12(%ebp), %eax
	movl	%eax, -16(%ebp)
	jmp	.L164
.L167:
	jmp	.L164
.L165:
	cmpl	$0, -20(%ebp)
	jne	.L168
	movl	-12(%ebp), %eax
	movl	%eax, -20(%ebp)
	jmp	.L176
.L168:
.L176:
	nop
.L164:
	movl	-12(%ebp), %eax
	movl	28(%eax), %eax
	movl	%eax, -12(%ebp)
.L163:
	cmpl	$0, -12(%ebp)
	jne	.L169
	cmpl	$0, -16(%ebp)
	jne	.L170
	movl	28(%ebp), %eax
	movl	$0, (%eax)
	jmp	.L171
.L170:
	movl	-16(%ebp), %eax
	movl	16(%eax), %eax
	cmpl	24(%ebp), %eax
	jbe	.L172
	movl	-16(%ebp), %eax
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
.L172:
	movl	24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	20(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	-16(%ebp), %eax
	movl	16(%eax), %edx
	movl	-16(%ebp), %eax
	movl	20(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	20(%ebp), %eax
	movl	%eax, (%esp)
	call	memmove
	movl	28(%ebp), %eax
	movl	$1, (%eax)
.L171:
	cmpl	$0, -20(%ebp)
	jne	.L173
	movl	16(%ebp), %eax
	movl	$0, (%eax)
	jmp	.L174
.L173:
	movl	-20(%ebp), %eax
	movl	16(%eax), %eax
	cmpl	12(%ebp), %eax
	jbe	.L175
	movl	-20(%ebp), %eax
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
.L175:
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	-20(%ebp), %eax
	movl	16(%eax), %edx
	movl	-20(%ebp), %eax
	movl	20(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	memmove
	movl	16(%ebp), %eax
	movl	$1, (%eax)
.L174:
	movl	-72(%ebp), %eax
	movl	%eax, (%esp)
	call	freeaddrinfo
	addl	$100, %esp
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
	movl	$.LC71, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	jne	.L178
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC13, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L178:
	movl	$0, 4(%esp)
	leal	-10036(%ebp), %eax
	movl	%eax, (%esp)
	call	gettimeofday
	jmp	.L179
.L193:
	movl	$35, 4(%esp)
	leal	-5020(%ebp), %eax
	movl	%eax, (%esp)
	call	strchr
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	je	.L180
	movl	-20(%ebp), %eax
	movb	$0, (%eax)
.L180:
	leal	-5020(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	movl	%eax, -12(%ebp)
	jmp	.L181
.L183:
	subl	$1, -12(%ebp)
	leal	-5020(%ebp), %edx
	movl	-12(%ebp), %eax
	addl	%edx, %eax
	movb	$0, (%eax)
.L181:
	cmpl	$0, -12(%ebp)
	jle	.L182
	movl	-12(%ebp), %eax
	subl	$1, %eax
	movzbl	-5020(%ebp,%eax), %eax
	cmpb	$32, %al
	je	.L183
	movl	-12(%ebp), %eax
	subl	$1, %eax
	movzbl	-5020(%ebp,%eax), %eax
	cmpb	$9, %al
	je	.L183
	movl	-12(%ebp), %eax
	subl	$1, %eax
	movzbl	-5020(%ebp,%eax), %eax
	cmpb	$10, %al
	je	.L183
	movl	-12(%ebp), %eax
	subl	$1, %eax
	movzbl	-5020(%ebp,%eax), %eax
	cmpb	$13, %al
	je	.L183
.L182:
	cmpl	$0, -12(%ebp)
	jne	.L184
	jmp	.L179
.L184:
	leal	-10024(%ebp), %eax
	movl	%eax, 16(%esp)
	leal	-10028(%ebp), %eax
	movl	%eax, 12(%esp)
	leal	-10020(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC108, 4(%esp)
	leal	-5020(%ebp), %eax
	movl	%eax, (%esp)
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L185
	leal	-10024(%ebp), %eax
	movl	%eax, 12(%esp)
	leal	-10020(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC109, 4(%esp)
	leal	-5020(%ebp), %eax
	movl	%eax, (%esp)
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L186
	movl	$0, -10028(%ebp)
	jmp	.L185
.L186:
	leal	-5020(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC110, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	argv0, %edx
	movl	stderr, %eax
	leal	-5020(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	8(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC111, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	jmp	.L179
.L185:
	movzbl	-10020(%ebp), %eax
	cmpb	$47, %al
	jne	.L187
	leal	-10020(%ebp), %eax
	addl	$1, %eax
	movl	%eax, 4(%esp)
	leal	-10020(%ebp), %eax
	movl	%eax, (%esp)
	call	strcpy
	jmp	.L188
.L187:
	jmp	.L188
.L189:
	movl	-20(%ebp), %eax
	leal	2(%eax), %edx
	movl	-20(%ebp), %eax
	addl	$1, %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	strcpy
.L188:
	movl	$.LC112, 4(%esp)
	leal	-10020(%ebp), %eax
	movl	%eax, (%esp)
	call	strstr
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	jne	.L189
	movl	numthrottles, %edx
	movl	maxthrottles, %eax
	cmpl	%eax, %edx
	jl	.L190
	movl	maxthrottles, %eax
	testl	%eax, %eax
	jne	.L191
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
	jmp	.L192
.L191:
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
.L192:
	movl	throttles, %eax
	testl	%eax, %eax
	jne	.L190
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
.L190:
	movl	throttles, %ecx
	movl	numthrottles, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	leal	(%ecx,%eax), %ebx
	leal	-10020(%ebp), %eax
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
	movl	-10024(%ebp), %eax
	movl	%eax, 4(%edx)
	movl	throttles, %ecx
	movl	numthrottles, %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	leal	(%ecx,%eax), %edx
	movl	-10028(%ebp), %eax
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
.L179:
	movl	-16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$5000, 4(%esp)
	leal	-5020(%ebp), %eax
	movl	%eax, (%esp)
	call	fgets
	testl	%eax, %eax
	jne	.L193
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	fclose
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
	leal	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	gettimeofday
	leal	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	logstats
	movl	$0, -12(%ebp)
	jmp	.L195
.L198:
	movl	connects, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L196
	movl	connects, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	8(%eax), %eax
	leal	-24(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	httpd_close_conn
.L196:
	movl	connects, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	je	.L197
	movl	connects, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	8(%eax), %eax
	movl	%eax, (%esp)
	call	httpd_destroy_conn
	movl	connects, %ecx
	movl	-12(%ebp), %edx
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
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	$0, 8(%eax)
.L197:
	addl	$1, -12(%ebp)
.L195:
	movl	max_connects, %eax
	cmpl	%eax, -12(%ebp)
	jl	.L198
	movl	hs, %eax
	testl	%eax, %eax
	je	.L199
	movl	hs, %eax
	movl	%eax, -16(%ebp)
	movl	$0, hs
	movl	-16(%ebp), %eax
	movl	40(%eax), %eax
	cmpl	$-1, %eax
	je	.L200
	movl	-16(%ebp), %eax
	movl	40(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
.L200:
	movl	-16(%ebp), %eax
	movl	44(%eax), %eax
	cmpl	$-1, %eax
	je	.L201
	movl	-16(%ebp), %eax
	movl	44(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
.L201:
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_terminate
.L199:
	call	mmc_destroy
	call	tmr_destroy
	movl	connects, %eax
	movl	%eax, (%esp)
	call	free
	movl	throttles, %eax
	testl	%eax, %eax
	je	.L194
	movl	throttles, %eax
	movl	%eax, (%esp)
	call	free
.L194:
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
.L214:
	movl	num_connects, %edx
	movl	max_connects, %eax
	cmpl	%eax, %edx
	jl	.L204
	movl	$.LC115, 4(%esp)
	movl	$4, (%esp)
	call	syslog
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	tmr_run
	movl	$0, %eax
	jmp	.L215
.L204:
	movl	first_free_connect, %eax
	cmpl	$-1, %eax
	je	.L206
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
	je	.L207
.L206:
	movl	$.LC116, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L207:
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
	jne	.L208
	movl	$456, (%esp)
	call	malloc
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	-12(%ebp), %eax
	movl	8(%eax), %eax
	testl	%eax, %eax
	jne	.L209
	movl	$.LC117, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L209:
	movl	-12(%ebp), %eax
	movl	8(%eax), %eax
	movl	$0, (%eax)
	movl	httpd_conn_count, %eax
	addl	$1, %eax
	movl	%eax, httpd_conn_count
.L208:
	movl	-12(%ebp), %eax
	movl	8(%eax), %edx
	movl	hs, %eax
	movl	%edx, 8(%esp)
	movl	12(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	httpd_get_conn
	testl	%eax, %eax
	je	.L211
	cmpl	$2, %eax
	je	.L212
	jmp	.L216
.L211:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	tmr_run
	movl	$0, %eax
	jmp	.L215
.L212:
	movl	$1, %eax
	jmp	.L215
.L216:
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
	jle	.L213
	movl	num_connects, %eax
	movl	%eax, stats_simultaneous
	jmp	.L214
.L213:
	jmp	.L214
.L215:
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
	jb	.L218
	movl	-16(%ebp), %eax
	movl	140(%eax), %eax
	cmpl	$5000, %eax
	jbe	.L219
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
	jmp	.L217
.L219:
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
.L218:
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
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	jne	.L221
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
	jmp	.L217
.L221:
	cmpl	$0, -20(%ebp)
	jns	.L222
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L223
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	je	.L223
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	jne	.L224
.L223:
	jmp	.L217
.L224:
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
	jmp	.L217
.L222:
	movl	-16(%ebp), %eax
	movl	144(%eax), %edx
	movl	-20(%ebp), %eax
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
	je	.L240
	cmpl	$2, %eax
	jne	.L239
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
	jmp	.L217
.L239:
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_parse_request
	testl	%eax, %eax
	jns	.L228
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L217
.L228:
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	check_throttles
	testl	%eax, %eax
	jne	.L229
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
	jmp	.L217
.L229:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_start_request
	testl	%eax, %eax
	jns	.L230
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L217
.L230:
	movl	-16(%ebp), %eax
	movl	336(%eax), %eax
	testl	%eax, %eax
	je	.L231
	movl	-16(%ebp), %eax
	movl	344(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 92(%eax)
	movl	-16(%ebp), %eax
	movl	348(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 88(%eax)
	jmp	.L232
.L231:
	movl	-16(%ebp), %eax
	movl	164(%eax), %eax
	testl	%eax, %eax
	jns	.L233
	movl	8(%ebp), %eax
	movl	$0, 88(%eax)
	jmp	.L232
.L233:
	movl	-16(%ebp), %eax
	movl	164(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 88(%eax)
.L232:
	movl	-16(%ebp), %eax
	movl	452(%eax), %eax
	testl	%eax, %eax
	jne	.L234
	movl	$0, -12(%ebp)
	jmp	.L235
.L236:
	movl	throttles, %ecx
	movl	8(%ebp), %eax
	movl	-12(%ebp), %edx
	movl	12(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%eax, %ecx
	movl	throttles, %ebx
	movl	8(%ebp), %eax
	movl	-12(%ebp), %edx
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
	addl	$1, -12(%ebp)
.L235:
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	cmpl	-12(%ebp), %eax
	jg	.L236
	movl	-16(%ebp), %eax
	movl	168(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 92(%eax)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L217
.L234:
	movl	8(%ebp), %eax
	movl	92(%eax), %edx
	movl	8(%ebp), %eax
	movl	88(%eax), %eax
	cmpl	%eax, %edx
	jl	.L237
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L217
.L237:
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
	jmp	.L217
.L240:
	nop
.L217:
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
	movl	%eax, -28(%ebp)
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	cmpl	$-1, %eax
	jne	.L242
	movl	$1000000000, -12(%ebp)
	jmp	.L243
.L242:
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	leal	3(%eax), %edx
	testl	%eax, %eax
	cmovs	%edx, %eax
	sarl	$2, %eax
	movl	%eax, -12(%ebp)
.L243:
	movl	-28(%ebp), %eax
	movl	304(%eax), %eax
	testl	%eax, %eax
	jne	.L244
	movl	8(%ebp), %eax
	movl	88(%eax), %edx
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	cmpl	%eax, %edx
	cmova	%eax, %edx
	movl	-28(%ebp), %eax
	movl	452(%eax), %ecx
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	addl	%eax, %ecx
	movl	-28(%ebp), %eax
	movl	448(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	call	write
	movl	%eax, -16(%ebp)
	jmp	.L245
.L244:
	movl	-28(%ebp), %eax
	movl	252(%eax), %eax
	movl	%eax, -56(%ebp)
	movl	-28(%ebp), %eax
	movl	304(%eax), %eax
	movl	%eax, -52(%ebp)
	movl	-28(%ebp), %eax
	movl	452(%eax), %edx
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	addl	%edx, %eax
	movl	%eax, -48(%ebp)
	movl	8(%ebp), %eax
	movl	88(%eax), %edx
	movl	8(%ebp), %eax
	movl	92(%eax), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	cmpl	%eax, %edx
	cmovbe	%edx, %eax
	movl	%eax, -44(%ebp)
	movl	-28(%ebp), %eax
	movl	448(%eax), %eax
	movl	$2, 8(%esp)
	leal	-56(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	writev
	movl	%eax, -16(%ebp)
.L245:
	cmpl	$0, -16(%ebp)
	jns	.L246
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	jne	.L246
	jmp	.L241
.L246:
	cmpl	$0, -16(%ebp)
	je	.L248
	cmpl	$0, -16(%ebp)
	jns	.L249
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	je	.L248
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	jne	.L249
.L248:
	movl	8(%ebp), %eax
	movl	80(%eax), %eax
	leal	100(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 80(%eax)
	movl	8(%ebp), %eax
	movl	$3, (%eax)
	movl	-28(%ebp), %eax
	movl	448(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
	movl	8(%ebp), %eax
	movl	%eax, -40(%ebp)
	movl	8(%ebp), %eax
	movl	72(%eax), %eax
	testl	%eax, %eax
	je	.L250
	movl	$.LC118, 4(%esp)
	movl	$3, (%esp)
	call	syslog
.L250:
	movl	8(%ebp), %eax
	movl	80(%eax), %eax
	movl	$0, 16(%esp)
	movl	%eax, 12(%esp)
	movl	-40(%ebp), %eax
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
	jne	.L251
	movl	$.LC119, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L251:
	jmp	.L241
.L249:
	cmpl	$0, -16(%ebp)
	jns	.L252
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$32, %eax
	je	.L253
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$22, %eax
	je	.L253
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$104, %eax
	je	.L253
	movl	-28(%ebp), %eax
	movl	172(%eax), %eax
	movl	%eax, 8(%esp)
	movl	$.LC120, 4(%esp)
	movl	$3, (%esp)
	call	syslog
.L253:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	clear_connection
	jmp	.L241
.L252:
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 68(%eax)
	movl	-28(%ebp), %eax
	movl	304(%eax), %eax
	testl	%eax, %eax
	je	.L254
	movl	-16(%ebp), %edx
	movl	-28(%ebp), %eax
	movl	304(%eax), %eax
	cmpl	%eax, %edx
	jae	.L255
	movl	-28(%ebp), %eax
	movl	304(%eax), %edx
	movl	-16(%ebp), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -32(%ebp)
	movl	-32(%ebp), %edx
	movl	-28(%ebp), %eax
	movl	252(%eax), %ecx
	movl	-16(%ebp), %eax
	addl	%eax, %ecx
	movl	-28(%ebp), %eax
	movl	252(%eax), %eax
	movl	%edx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	call	memmove
	movl	-32(%ebp), %edx
	movl	-28(%ebp), %eax
	movl	%edx, 304(%eax)
	movl	$0, -16(%ebp)
	jmp	.L254
.L255:
	movl	-16(%ebp), %edx
	movl	-28(%ebp), %eax
	movl	304(%eax), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -16(%ebp)
	movl	-28(%ebp), %eax
	movl	$0, 304(%eax)
.L254:
	movl	8(%ebp), %eax
	movl	92(%eax), %edx
	movl	-16(%ebp), %eax
	addl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 92(%eax)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	8(%ebp), %edx
	movl	8(%edx), %edx
	movl	168(%edx), %ecx
	movl	-16(%ebp), %edx
	addl	%ecx, %edx
	movl	%edx, 168(%eax)
	movl	$0, -24(%ebp)
	jmp	.L256
.L257:
	movl	throttles, %ecx
	movl	8(%ebp), %eax
	movl	-24(%ebp), %edx
	movl	12(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%eax, %ecx
	movl	throttles, %ebx
	movl	8(%ebp), %eax
	movl	-24(%ebp), %edx
	movl	12(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	16(%eax), %edx
	movl	-16(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, 16(%ecx)
	addl	$1, -24(%ebp)
.L256:
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	cmpl	-24(%ebp), %eax
	jg	.L257
	movl	8(%ebp), %eax
	movl	92(%eax), %edx
	movl	8(%ebp), %eax
	movl	88(%eax), %eax
	cmpl	%eax, %edx
	jl	.L258
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L241
.L258:
	movl	8(%ebp), %eax
	movl	80(%eax), %eax
	cmpl	$100, %eax
	jle	.L259
	movl	8(%ebp), %eax
	movl	80(%eax), %eax
	leal	-100(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 80(%eax)
.L259:
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	cmpl	$-1, %eax
	je	.L241
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	64(%eax), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	jne	.L261
	movl	$1, -20(%ebp)
.L261:
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	168(%eax), %eax
	cltd
	idivl	-20(%ebp)
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	cmpl	%eax, %edx
	jle	.L241
	movl	8(%ebp), %eax
	movl	$3, (%eax)
	movl	-28(%ebp), %eax
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
	subl	-20(%ebp), %eax
	movl	%eax, -36(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -40(%ebp)
	movl	8(%ebp), %eax
	movl	72(%eax), %eax
	testl	%eax, %eax
	je	.L262
	movl	$.LC118, 4(%esp)
	movl	$3, (%esp)
	call	syslog
.L262:
	cmpl	$0, -36(%ebp)
	jle	.L263
	movl	-36(%ebp), %eax
	imull	$1000, %eax, %eax
	jmp	.L264
.L263:
	movl	$500, %eax
.L264:
	movl	$0, 16(%esp)
	movl	%eax, 12(%esp)
	movl	-40(%ebp), %eax
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
	jne	.L241
	movl	$.LC119, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L241:
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
	subl	$4136, %esp
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	448(%eax), %eax
	movl	$4096, 8(%esp)
	leal	-4108(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	read
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jns	.L267
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L266
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$11, %eax
	je	.L266
.L267:
	cmpl	$0, -12(%ebp)
	jg	.L266
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	really_clear_connection
.L266:
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
	movl	$0, -12(%ebp)
	jmp	.L272
.L282:
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	188(%eax), %ecx
	movl	throttles, %ebx
	movl	-12(%ebp), %edx
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
	je	.L273
	movl	throttles, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %ebx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	4(%eax), %eax
	addl	%eax, %eax
	cmpl	%eax, %ecx
	jle	.L274
	movl	$0, %eax
	jmp	.L275
.L274:
	movl	throttles, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %ebx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	8(%eax), %eax
	cmpl	%eax, %ecx
	jge	.L276
	movl	$0, %eax
	jmp	.L275
.L276:
	movl	throttles, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %eax
	testl	%eax, %eax
	jns	.L277
	movl	$.LC121, 4(%esp)
	movl	$3, (%esp)
	call	syslog
	movl	throttles, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	$0, 20(%eax)
.L277:
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	leal	1(%eax), %ecx
	movl	8(%ebp), %edx
	movl	%ecx, 52(%edx)
	movl	8(%ebp), %edx
	movl	-12(%ebp), %ecx
	movl	%ecx, 12(%edx,%eax,4)
	movl	throttles, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %edx
	addl	$1, %edx
	movl	%edx, 20(%eax)
	movl	throttles, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	4(%eax), %ecx
	movl	throttles, %ebx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	20(%eax), %esi
	movl	%ecx, %eax
	cltd
	idivl	%esi
	movl	%eax, -16(%ebp)
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	cmpl	$-1, %eax
	jne	.L278
	movl	8(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, 56(%eax)
	jmp	.L279
.L278:
	movl	8(%ebp), %eax
	movl	56(%eax), %edx
	movl	-16(%ebp), %eax
	cmpl	%eax, %edx
	cmovg	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 56(%eax)
.L279:
	movl	throttles, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	8(%eax), %eax
	movl	%eax, -16(%ebp)
	movl	8(%ebp), %eax
	movl	60(%eax), %eax
	cmpl	$-1, %eax
	jne	.L280
	movl	8(%ebp), %eax
	movl	-16(%ebp), %edx
	movl	%edx, 60(%eax)
	jmp	.L273
.L280:
	movl	8(%ebp), %eax
	movl	60(%eax), %edx
	movl	-16(%ebp), %eax
	cmpl	%eax, %edx
	cmovl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 60(%eax)
.L273:
	addl	$1, -12(%ebp)
.L272:
	movl	numthrottles, %eax
	cmpl	%eax, -12(%ebp)
	jge	.L281
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	cmpl	$9, %eax
	jle	.L282
.L281:
	movl	$1, %eax
.L275:
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
	jmp	.L284
.L285:
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
.L284:
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	cmpl	-4(%ebp), %eax
	jg	.L285
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
	movl	$0, -28(%ebp)
	jmp	.L287
.L291:
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	leal	(%ecx,%eax), %ebx
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %eax
	leal	(%eax,%eax), %esi
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
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
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	$0, 16(%eax)
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %ebx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	4(%eax), %eax
	cmpl	%eax, %ecx
	jle	.L288
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %eax
	testl	%eax, %eax
	je	.L288
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %ebx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	4(%eax), %eax
	addl	%eax, %eax
	cmpl	%eax, %ecx
	jle	.L289
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %esi
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	4(%eax), %ebx
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %edi
	movl	-28(%ebp), %edx
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
	movl	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC122, 4(%esp)
	movl	$5, (%esp)
	call	syslog
	jmp	.L288
.L289:
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %esi
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	4(%eax), %ebx
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %edi
	movl	-28(%ebp), %edx
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
	movl	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC123, 4(%esp)
	movl	$6, (%esp)
	call	syslog
.L288:
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %ebx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	8(%eax), %eax
	cmpl	%eax, %ecx
	jge	.L290
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %eax
	testl	%eax, %eax
	je	.L290
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	20(%eax), %esi
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	8(%eax), %ebx
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	12(%eax), %ecx
	movl	throttles, %edi
	movl	-28(%ebp), %edx
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
	movl	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC124, 4(%esp)
	movl	$5, (%esp)
	call	syslog
.L290:
	addl	$1, -28(%ebp)
.L287:
	movl	numthrottles, %eax
	cmpl	%eax, -28(%ebp)
	jl	.L291
	movl	$0, -36(%ebp)
	jmp	.L292
.L299:
	movl	connects, %ecx
	movl	-36(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	%eax, -40(%ebp)
	movl	-40(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$2, %eax
	je	.L293
	movl	-40(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$3, %eax
	jne	.L294
.L293:
	movl	-40(%ebp), %eax
	movl	$-1, 56(%eax)
	movl	$0, -32(%ebp)
	jmp	.L295
.L298:
	movl	-40(%ebp), %eax
	movl	-32(%ebp), %edx
	movl	12(%eax,%edx,4), %eax
	movl	%eax, -28(%ebp)
	movl	throttles, %ecx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ecx, %eax
	movl	4(%eax), %ecx
	movl	throttles, %ebx
	movl	-28(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$3, %eax
	addl	%ebx, %eax
	movl	20(%eax), %edi
	movl	%ecx, %eax
	cltd
	idivl	%edi
	movl	%eax, -44(%ebp)
	movl	-40(%ebp), %eax
	movl	56(%eax), %eax
	cmpl	$-1, %eax
	jne	.L296
	movl	-40(%ebp), %eax
	movl	-44(%ebp), %edx
	movl	%edx, 56(%eax)
	jmp	.L297
.L296:
	movl	-40(%ebp), %eax
	movl	56(%eax), %edx
	movl	-44(%ebp), %eax
	cmpl	%eax, %edx
	cmovg	%eax, %edx
	movl	-40(%ebp), %eax
	movl	%edx, 56(%eax)
.L297:
	addl	$1, -32(%ebp)
.L295:
	movl	-40(%ebp), %eax
	movl	52(%eax), %eax
	cmpl	-32(%ebp), %eax
	jg	.L298
.L294:
	addl	$1, -36(%ebp)
.L292:
	movl	max_connects, %eax
	cmpl	%eax, -36(%ebp)
	jl	.L299
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
	je	.L302
	movl	8(%ebp), %eax
	movl	72(%eax), %eax
	movl	%eax, (%esp)
	call	tmr_cancel
	movl	8(%ebp), %eax
	movl	$0, 72(%eax)
.L302:
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$4, %eax
	jne	.L303
	movl	8(%ebp), %eax
	movl	76(%eax), %eax
	movl	%eax, (%esp)
	call	tmr_cancel
	movl	8(%ebp), %eax
	movl	$0, 76(%eax)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	$0, 356(%eax)
.L303:
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	356(%eax), %eax
	testl	%eax, %eax
	je	.L304
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$3, %eax
	je	.L305
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	448(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
.L305:
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
	je	.L306
	movl	$.LC125, 4(%esp)
	movl	$3, (%esp)
	call	syslog
.L306:
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
	jne	.L301
	movl	$.LC126, 4(%esp)
	movl	$2, (%esp)
	call	syslog
	movl	$1, (%esp)
	call	exit
.L304:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	really_clear_connection
.L301:
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
	je	.L309
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	448(%eax), %eax
	movl	%eax, (%esp)
	call	fdwatch_del_fd
.L309:
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
	je	.L310
	movl	8(%ebp), %eax
	movl	76(%eax), %eax
	movl	%eax, (%esp)
	call	tmr_cancel
	movl	8(%ebp), %eax
	movl	$0, 76(%eax)
.L310:
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
	movl	$0, -12(%ebp)
	jmp	.L312
.L318:
	movl	connects, %ecx
	movl	-12(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$5, %eax
	addl	%ecx, %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$1, %eax
	je	.L314
	cmpl	$1, %eax
	jl	.L313
	cmpl	$3, %eax
	jg	.L313
	jmp	.L319
.L314:
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	-16(%ebp), %eax
	movl	68(%eax), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	cmpl	$59, %eax
	jle	.L316
	movl	-16(%ebp), %eax
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
	movl	-16(%ebp), %eax
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
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	finish_connection
	jmp	.L313
.L316:
	jmp	.L313
.L319:
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	-16(%ebp), %eax
	movl	68(%eax), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	cmpl	$299, %eax
	jle	.L317
	movl	-16(%ebp), %eax
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
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	clear_connection
	jmp	.L320
.L317:
.L320:
	nop
.L313:
	addl	$1, -12(%ebp)
.L312:
	movl	max_connects, %eax
	cmpl	%eax, -12(%ebp)
	jl	.L318
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
	jne	.L321
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
.L321:
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
	jne	.L327
	movl	$0, 4(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	gettimeofday
	leal	-28(%ebp), %eax
	movl	%eax, 8(%ebp)
.L327:
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -16(%ebp)
	movl	start_time, %eax
	movl	-16(%ebp), %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -20(%ebp)
	movl	stats_time, %eax
	movl	-16(%ebp), %edx
	subl	%eax, %edx
	movl	%edx, %eax
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L328
	movl	$1, -12(%ebp)
.L328:
	movl	-16(%ebp), %eax
	movl	%eax, stats_time
	movl	-12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC129, 4(%esp)
	movl	$6, (%esp)
	call	syslog
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	thttpd_logstats
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	httpd_logstats
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	mmc_logstats
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	fdwatch_logstats
	movl	-12(%ebp), %eax
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
	jle	.L330
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
.L330:
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
