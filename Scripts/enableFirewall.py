import subprocess
import argparse

import shutil, os, glob
import admin





def EnableFirewall(target):
      name = os.path.basename(target).replace(".exe","")
      target = os.path.abspath(target)
      print("enabling %s"%target)
      cmd_in = 'netsh.exe advfirewall firewall add rule name="%s" dir=in  action=allow program="%s" enable=yes'%(name, target)
      cmd_out = 'netsh.exe advfirewall firewall add rule name="%s" dir=out action=allow program="%s" enable=yes'%(name, target)

      with subprocess.Popen(cmd_in) as proc:
          proc.wait()
      with subprocess.Popen(cmd_out) as proc:
          proc.wait()

def EnableAllPrograms():
    for file in glob.glob("Environment/Adapters/**/*.exe"):
            EnableFirewall(file)
    for file in glob.glob("Environment/Launcher/*.exe"):
            EnableFirewall(file)
    for file in glob.glob("Environment/Services/**/*.exe"):
            EnableFirewall(file)
    finsih = input("Finished")



## The following code was adapted from: 
# https://stackoverflow.com/questions/19672352/how-to-run-python-script-with-elevated-privilege-on-windows

import sys, os, traceback, types

def isUserAdmin():

    if os.name == 'nt':
        import ctypes
        # WARNING: requires Windows XP SP2 or higher!
        try:
            return ctypes.windll.shell32.IsUserAnAdmin()
        except:
            traceback.print_exc()
            print("Admin check failed, assuming not an admin.")
            return False
    elif os.name == 'posix':
        # Check for root on Posix
        return os.getuid() == 0
    else:
        raise RuntimeError("Unsupported operating system for this module: %s" % (os.name,))

def runAsAdmin(cmdLine=None, wait=True):

    if os.name != 'nt':
        raise RuntimeError("This function is only implemented on Windows.")

    import win32api, win32con, win32event, win32process
    from win32com.shell.shell import ShellExecuteEx
    from win32com.shell import shellcon

    python_exe = sys.executable

    if cmdLine is None:
        cmdLine = [python_exe] + sys.argv
    elif type(cmdLine) not in (types.TupleType,types.ListType):
        raise ValueError("cmdLine is not a sequence.")
    cmd = '"%s"' % (cmdLine[0],)
    # XXX TODO: isn't there a function or something we can call to massage command line params?
    params = " ".join(['"%s"' % (x,) for x in cmdLine[1:]])
    cmdDir = ''
    showCmd = win32con.SW_SHOWNORMAL
    #showCmd = win32con.SW_HIDE
    lpVerb = 'runas'  # causes UAC elevation prompt.

    # print "Running", cmd, params

    # ShellExecute() doesn't seem to allow us to fetch the PID or handle
    # of the process, so we can't get anything useful from it. Therefore
    # the more complex ShellExecuteEx() must be used.

    # procHandle = win32api.ShellExecute(0, lpVerb, cmd, params, cmdDir, showCmd)

    procInfo = ShellExecuteEx(nShow=showCmd,
                              fMask=shellcon.SEE_MASK_NOCLOSEPROCESS,
                              lpVerb=lpVerb,
                              lpFile=cmd,
                              lpParameters=params)

    if wait:
        procHandle = procInfo['hProcess']    
        obj = win32event.WaitForSingleObject(procHandle, win32event.INFINITE)
        rc = win32process.GetExitCodeProcess(procHandle)
        #print "Process handle %s returned code %s" % (procHandle, rc)
    else:
        rc = None

    return rc

def execute():
    rc = 0
    if not isUserAdmin():
        print("You're not an admin.", os.getpid(), "params: ", sys.argv)
        #rc = runAsAdmin(["c:\\Windows\\notepad.exe"])
        rc = runAsAdmin()
    else:
        print("You are an admin!", os.getpid(), "params: ", sys.argv)
        rc = 0
        EnableAllPrograms()
    x = raw_input('Press Enter to exit.')
    return rc


if __name__ == "__main__":
    sys.exit(execute())