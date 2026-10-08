{
  pasfetch
  Copyright (C) 2026 alek-dread

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, version 3 of the License.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU General Public License for more details.

  SPDX-License-Identifier: GPL-3.0-only
}

program pasfetch;

const
  PRODUCT_NAME = '/sys/devices/virtual/dmi/id/product_name';
  OS_FILE = '/etc/os-release';
  KERNEL_FILE = '/proc/sys/kernel/osrelease';
  UPTIME_FILE = '/proc/uptime';
  MEMINFO_FILE = '/proc/meminfo';
  CPUINFO_FILE = '/proc/cpuinfo';
  SHELL_FILE = '/proc/self/status';
  ENV_FILE = '/proc/self/environ';

  DEBIAN_ID = 1;
  FEDORA_ID = 2;
  UBUNTU_ID = 3;
  ARCH_ID = 4;

  RESET_COLOR = #27'[0m';
  RED = #27'[31m';
  GREEN = #27'[32m';
  YELLOW = #27'[33m';
  BLUE = #27'[34m';
  MAGENTA = #27'[35m';
  CYAN = #27'[36m';
  WHITE = #27'[37m';
  ORANGE = #27'[38;5;208m';

  NUMBER_OF_PARAMS = 1;

procedure GetOSID(filename: string; var os_id: byte);
var
  id_file_var: text;
  line: string;
begin
  os_id := 0;
  assign(id_file_var, filename);
  reset(id_file_var);
  while not eof(id_file_var) do
  begin
    readln(id_file_var, line);
    if pos('ID=fedora', line) = 1 then
    begin
      os_id := FEDORA_ID;
      break;
    end
    else if pos('ID=debian', line) = 1 then
    begin
      os_id := DEBIAN_ID;
      break;
    end
    else if pos('ID=ubuntu', line) = 1 then
    begin
      os_id := UBUNTU_ID;
      break;
    end
    else if pos('ID=arch', line) = 1 then
    begin
      os_id := ARCH_ID;
      break;
    end;
  end;
  close(id_file_var);
end;

procedure GetLogoOSID(var os_id: byte);
var
  arg: string;
begin
  if ParamCount > 0 then
  begin
    arg := ParamStr(NUMBER_OF_PARAMS);

    if arg = '--os=debian' then
      os_id := DEBIAN_ID
    else if arg = '--os=fedora' then
      os_id := FEDORA_ID
    else if arg = '--os=ubuntu' then
      os_id := UBUNTU_ID
    else if arg = '--os=arch' then
      os_id := ARCH_ID
    else
      GetOSID(OS_FILE, os_id);
  end
  else
    GetOSID(OS_FILE, os_id);
end;

procedure WriteLogo(os_id: byte);
begin
  if os_id = DEBIAN_ID then
  begin
    writeln;
    writeln(RED, '  _____       _     _             ', RESET_COLOR);
    writeln(RED, ' |  __ \     | |   (_)            ', RESET_COLOR);
    writeln(RED, ' | |  | | ___| |__  _  __ _ _ __  ', RESET_COLOR);
    writeln(RED, ' | |  | |/ _ \ ''_ \| |/ _` | ''_ \ ', RESET_COLOR);
    writeln(RED, ' | |__| |  __/ |_) | | (_| | | | |', RESET_COLOR);
    writeln(RED, ' |_____/ \___|_.__/|_|\__,_|_| |_|', RESET_COLOR);
    writeln(RED, '                                  ', RESET_COLOR);
  end
  else if os_id = FEDORA_ID then
  begin
    writeln;
    writeln(CYAN, '  ______       _                 ', RESET_COLOR);
    writeln(CYAN, ' |  ____|     | |                ', RESET_COLOR);
    writeln(CYAN, ' | |__ ___  __| | ___  _ __ __ _ ', RESET_COLOR);
    writeln(CYAN, ' |  __/ _ \/ _` |/ _ \| ''__/ _` |', RESET_COLOR);
    writeln(CYAN, ' | | |  __/ (_| | (_) | | | (_| |', RESET_COLOR);
    writeln(CYAN, ' |_|  \___|\__,_|\___/|_|  \__,_|', RESET_COLOR);
    writeln(CYAN, '                                 ', RESET_COLOR);
  end
  else if os_id = UBUNTU_ID then
  begin
    writeln;
    writeln(ORANGE, '  _    _ _                 _         ', RESET_COLOR);
    writeln(ORANGE, ' | |  | | |               | |        ', RESET_COLOR);
    writeln(ORANGE, ' | |  | | |__  _   _ _ __ | |_ _   _ ', RESET_COLOR);
    writeln(ORANGE, ' | |  | | ''_ \| | | | ''_ \| __| | | |', RESET_COLOR);
    writeln(ORANGE, ' | |__| | |_) | |_| | | | | |_| |_| |', RESET_COLOR);
    writeln(ORANGE, '  \____/|_.__/ \__,_|_| |_|\__|\__,_|', RESET_COLOR);
    writeln(ORANGE, '                                     ', RESET_COLOR);
  end
  else if os_id = ARCH_ID then
  begin
    writeln;
    writeln(BLUE, '                    _     ', RESET_COLOR);
    writeln(BLUE, '     /\            | |    ', RESET_COLOR);
    writeln(BLUE, '    /  \   _ __ ___| |__  ', RESET_COLOR);
    writeln(BLUE, '   / /\ \ | ''__/ __| ''_ \ ', RESET_COLOR);
    writeln(BLUE, '  / ____ \| | | (__| | | |', RESET_COLOR);
    writeln(BLUE, ' /_/    \_\_|  \___|_| |_|', RESET_COLOR);
    writeln(BLUE, '                          ', RESET_COLOR);
  end;
end;

procedure WriteSingleLine(filename, label_text: string);
var
  file_var: text;
  line: string;
begin
  assign(file_var, filename);
  reset(file_var);
  readln(file_var, line);
  writeln(BLUE, label_text, RESET_COLOR, line);
  close(file_var);
end;

procedure WriteOSName(filename: string);
var
  os_file_var: text;
  line: string;
begin
  assign(os_file_var, filename);
  reset(os_file_var);
  while not eof(os_file_var) do 
  begin
    readln(os_file_var, line);
    if pos('PRETTY_NAME="', line) = 1 then
    begin
      delete(line, 1, length('PRETTY_NAME="'));
      delete(line, length(line), 1);
      writeln(BLUE, 'OS NAME  ', RESET_COLOR, line);
      break;
    end;
  end;
  close(os_file_var);
end;

procedure WriteUptime(filename: string);
var
  uptime_file_var: text;
  uptime_value: real;
  seconds: longint;
  hours: integer;
  minutes: integer;
begin
  assign(uptime_file_var, filename);
  reset(uptime_file_var);
  readln(uptime_file_var, uptime_value);
  seconds := trunc(uptime_value);
  hours := (seconds mod 86400) div 3600;
  minutes := (seconds mod 3600) div 60;
  writeln(BLUE, 'UPTIME   ', RESET_COLOR, hours, ' hours ', minutes, ' min');
  close(uptime_file_var);
end;

procedure ExtractNumber(var line: string; prefix: string);
var
  p: integer;
begin
  delete(line, 1, length(prefix));
  while (length(line) > 0) and (line[1] = ' ') do
    delete(line, 1, 1);
  p := pos(' ', line);
  if p > 0 then
    delete(line, p, length(line) - p + 1);
end;

procedure WriteMemory(filename: string);
var
  mem_file_var: text;
  line: string;
  total_kb: longint;
  available_kb: longint;
  used_kb: longint;
  total_mb: longint;
  used_mb: longint;
  code: integer;
begin
  total_kb := 0;
  available_kb := 0;
  assign(mem_file_var, filename);
  reset(mem_file_var);
  while not eof(mem_file_var) do
  begin
    readln(mem_file_var, line);
    if pos('MemTotal:', line) = 1 then
    begin
      ExtractNumber(line, 'MemTotal:');
      Val(line, total_kb, code);
      if code <> 0 then
      begin
        writeln('Error parsing MemTotal');
        break;
      end;
    end;
    if pos('MemAvailable:', line) = 1 then
    begin
      ExtractNumber(line, 'MemAvailable:');
      Val(line, available_kb, code);
      if code <> 0 then
      begin
        writeln('Error parsing MemTotal');
        break;
      end;
    end;
    if (total_kb > 0) and (available_kb > 0) then
      break;
  end;
  close(mem_file_var);
  used_kb := total_kb - available_kb;
  total_mb := total_kb div 1024;
  used_mb := used_kb div 1024;
  writeln(BLUE, 'MEMORY   ', RESET_COLOR, used_mb, ' MiB / ', total_mb, ' MiB');
end;

procedure WriteCPUName(filename: string);
var
  cpu_file_var: text;
  line: string;
  p: integer;
begin
  assign(cpu_file_var, filename);
  reset(cpu_file_var);
  while not eof(cpu_file_var) do
  begin
    readln(cpu_file_var, line);
    if pos('model name', line) = 1 then
    begin
      p := pos(':', line);
      if p > 0 then
      begin
        delete(line, 1, p);
        while (length(line) > 0) and (line[1] = ' ') do
          delete(line, 1, 1);
        writeln(BLUE, 'CPU      ', RESET_COLOR, line);
      end;
      break;
    end;
  end;
  close(cpu_file_var);
end;

procedure WriteShell(filename: string);
var
  status_file_var: text;
  shell_file_var: text;
  line: string;
  shell_name: string;
  ppid: longint;
  ppid_string: string;
  shell_filename: string;
  code: integer;
begin
  ppid := 0;
  code := -1;
  assign(status_file_var, filename);
  reset(status_file_var);
  while not eof(status_file_var) do
  begin
    readln(status_file_var, line);
    if pos('PPid:', line) = 1 then
    begin
      delete(line, 1, length('PPid:'));
      while (length(line) > 0) and
            ((line[1] = ' ') or (line[1] = #9)) do
        delete(line, 1, 1);
      Val(line, ppid, code);
      break;
    end;
  end;
  close(status_file_var);
  if code = 0 then
  begin
    str(ppid, ppid_string);
    shell_filename := '/proc/' + ppid_string + '/comm';
    assign(shell_file_var, shell_filename);
    reset(shell_file_var);
    readln(shell_file_var, shell_name);
    close(shell_file_var);
    writeln(BLUE, 'SHELL    ', RESET_COLOR, shell_name);
  end;
end;

procedure WriteWMName(filename: string);
var
  wm_file_var: text;
  ch: char;
  entery: string;
begin
  entery := '';
  assign(wm_file_var, filename);
  reset(wm_file_var);
  while not eof(wm_file_var) do
  begin
    read(wm_file_var, ch);
    if ch <> #0 then
      entery := entery + ch
    else
    begin
      if pos('XDG_CURRENT_DESKTOP=', entery) = 1 then
      begin
        delete(entery, 1, length('XDG_CURRENT_DESKTOP='));
        writeln(BLUE, 'DE       ', RESET_COLOR, entery);
        break;
      end
      else
        entery := '';
    end;
  end;
  close(wm_file_var);
end;

var
  os_id: byte;

begin
  GetLogoOSID(os_id);
  WriteLogo(os_id);
  WriteSingleLine(PRODUCT_NAME, 'HOST     ');
  WriteOSName(OS_FILE);
  WriteSingleLine(KERNEL_FILE, 'KERNEL   ');
  WriteShell(SHELL_FILE);
  WriteWMName(ENV_FILE);
  WriteUptime(UPTIME_FILE);
  WriteCPUName(CPUINFO_FILE);
  WriteMemory(MEMINFO_FILE);
  writeln;
end.

